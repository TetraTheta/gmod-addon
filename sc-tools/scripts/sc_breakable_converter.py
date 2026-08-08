"""Convert Hammer-authored sc_breakable VMF entities into standalone GLua."""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class VmfKeyValue:
    key: str
    value: str


@dataclass
class VmfBlock:
    name: str
    children: list[VmfBlock | VmfKeyValue] = field(default_factory=list)

    def blocks(self, name: str) -> list[VmfBlock]:
        name_lower = name.lower()
        return [child for child in self.children if isinstance(child, VmfBlock) and child.name.lower() == name_lower]

    def key(self, name: str) -> VmfKeyValue | None:
        name_lower = name.lower()
        for child in self.children:
            if isinstance(child, VmfKeyValue) and child.key.lower() == name_lower:
                return child
        return None

    def keyvalues(self) -> list[VmfKeyValue]:
        return [child for child in self.children if isinstance(child, VmfKeyValue)]


@dataclass(frozen=True)
class Vector3:
    x: float
    y: float
    z: float

    def __sub__(self, other: Vector3) -> Vector3:
        return Vector3(self.x - other.x, self.y - other.y, self.z - other.z)


class VmfParseError(ValueError):
    def __init__(self, message: str, text: str, index: int) -> None:
        line = text.count("\n", 0, index) + 1
        line_start = text.rfind("\n", 0, index) + 1
        super().__init__(f"{message} at line {line}, column {index - line_start + 1}")


class VmfParser:
    def __init__(self, text: str) -> None:
        self.index = 0
        self.length = len(text)
        self.text = text

    def parse(self) -> VmfBlock:
        root = VmfBlock("")
        root.children = self.parse_block(False)
        self.skip_ignored()
        if self.index < self.length:
            raise self.error("Unexpected trailing content")
        return root

    def parse_block(self, stop_at_closing_brace: bool) -> list[VmfBlock | VmfKeyValue]:
        children: list[VmfBlock | VmfKeyValue] = []
        while True:
            self.skip_ignored()
            if self.index >= self.length:
                if stop_at_closing_brace:
                    raise self.error("Missing closing brace")
                return children
            if self.text[self.index] == "}":
                if not stop_at_closing_brace:
                    raise self.error("Unexpected closing brace")
                self.index += 1
                return children

            key = self.read_token()
            self.skip_ignored()
            if self.index < self.length and self.text[self.index] == "{":
                self.index += 1
                children.append(VmfBlock(key, self.parse_block(True)))
                continue
            children.append(VmfKeyValue(key, self.read_token()))

    def error(self, message: str) -> VmfParseError:
        return VmfParseError(message, self.text, self.index)

    def peek(self, offset: int) -> str:
        peek_index = self.index + offset
        if peek_index >= self.length:
            return ""
        return self.text[peek_index]

    def read_quoted_token(self) -> str:
        self.index += 1
        chars: list[str] = []
        while self.index < self.length:
            char = self.text[self.index]
            if char == '"':
                self.index += 1
                return "".join(chars)
            if char == "\\" and self.peek(1) == '"':
                chars.append('"')
                self.index += 2
                continue
            chars.append(char)
            self.index += 1
        raise self.error("Unterminated quoted string")

    def read_token(self) -> str:
        self.skip_ignored()
        if self.index >= self.length:
            raise self.error("Unexpected end of file")
        if self.text[self.index] == '"':
            return self.read_quoted_token()

        start = self.index
        while self.index < self.length:
            char = self.text[self.index]
            if char.isspace() or char in "{}":
                break
            if char == "/" and self.peek(1) == "/":
                break
            self.index += 1
        if start == self.index:
            raise self.error(f"Unexpected character {self.text[self.index]!r}")
        return self.text[start : self.index]

    def skip_ignored(self) -> None:
        while self.index < self.length:
            char = self.text[self.index]
            if char.isspace():
                self.index += 1
                continue
            if char == "/" and self.peek(1) == "/":
                self.index += 2
                while self.index < self.length and self.text[self.index] not in "\r\n":
                    self.index += 1
                continue
            break


VECTOR_RE = re.compile(r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:e[-+]?\d+)?", re.IGNORECASE)
SC_BREAKABLE_KEYS = {
    "explodedamage",
    "explodemagnitude",
    "exploderadius",
    "explosion",
    "gibdir",
    "gibmodel",
    "health",
    "material",
    "minhealthdmg",
    "nodamageforces",
    "performancemode",
    "physdamagescale",
    "pressuredelay",
    "propdata",
    "spawnflags",
    "spawnobject",
    "startdisabled",
    "targetname",
}


def read_text(path: Path) -> str:
    for encoding in ("utf-8-sig", "utf-16", "cp949"):
        try:
            return path.read_text(encoding=encoding)
        except UnicodeError:
            continue
    return path.read_text(encoding="utf-8", errors="replace")


def parse_vector(value: str) -> Vector3:
    numbers = [float(match.group(0)) for match in VECTOR_RE.finditer(value)]
    if len(numbers) < 3:
        raise ValueError(f"Expected a 3D vector, got {value!r}")
    return Vector3(numbers[0], numbers[1], numbers[2])


def format_number(value: float) -> str:
    if abs(value) < 0.000001:
        value = 0
    text = f"{value:.6f}".rstrip("0").rstrip(".")
    return text or "0"


def format_vector(vector: Vector3) -> str:
    return f"{format_number(vector.x)} {format_number(vector.y)} {format_number(vector.z)}"


def key_value(block: VmfBlock, key: str, default: str = "") -> str:
    value = block.key(key)
    if value is None:
        return default
    return value.value


def collect_side_points(side: VmfBlock) -> list[Vector3]:
    points: list[Vector3] = []
    for vertices in side.blocks("vertices_plus"):
        for vertex in vertices.keyvalues():
            if vertex.key.lower() == "v":
                points.append(parse_vector(vertex.value))
    if points:
        return points

    plane = side.key("plane")
    if plane is None:
        return []
    return [parse_vector(match.group(0)) for match in re.finditer(r"\([^)]+\)", plane.value)]


def collect_solid_points(entity: VmfBlock) -> list[Vector3]:
    points: list[Vector3] = []
    for solid in entity.blocks("solid"):
        for side in solid.blocks("side"):
            points.extend(collect_side_points(side))
    return points


def compute_bounds(entity: VmfBlock) -> tuple[Vector3, Vector3]:
    origin = parse_vector(key_value(entity, "origin", "0 0 0"))
    points = collect_solid_points(entity)
    if not points:
        return parse_vector(key_value(entity, "mins", "-16 -16 -16")), parse_vector(
            key_value(entity, "maxs", "16 16 16")
        )

    world_mins = Vector3(
        min(point.x for point in points), min(point.y for point in points), min(point.z for point in points)
    )
    world_maxs = Vector3(
        max(point.x for point in points), max(point.y for point in points), max(point.z for point in points)
    )
    return world_mins - origin, world_maxs - origin


def escape_lua_string(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def lua_identifier(value: str, fallback: str, used_names: set[str]) -> str:
    name = re.sub(r"\W+", "_", value.strip())
    if not name or name[0].isdigit():
        name = fallback
    base_name = name
    index = 2
    while name in used_names:
        name = f"{base_name}_{index}"
        index += 1
    used_names.add(name)
    return name


def sc_breakable_entities(root: VmfBlock) -> list[VmfBlock]:
    return [block for block in root.blocks("entity") if key_value(block, "classname").lower() == "sc_breakable"]


def render_entity(entity: VmfBlock, used_names: set[str]) -> list[str]:
    entity_id = key_value(entity, "id", "unknown")
    targetname = key_value(entity, "targetname")
    var_name = lua_identifier(targetname, f"sc_breakable_{entity_id}", used_names)
    mins, maxs = compute_bounds(entity)

    lines = [
        f"-- VMF entity id: {entity_id}",
        f'local {var_name} = ents.Create("sc_breakable")',
        f"if IsValid({var_name}) then",
        f"  {var_name}:SetPos(Vector({format_vector(parse_vector(key_value(entity, 'origin', '0 0 0'))).replace(' ', ', ')}))",
    ]
    angles = key_value(entity, "angles")
    if angles:
        lines.append(f"  {var_name}:SetAngles(Angle({format_vector(parse_vector(angles)).replace(' ', ', ')}))")

    lines.append(f'  {var_name}:SetKeyValue("mins", "{format_vector(mins)}")')
    lines.append(f'  {var_name}:SetKeyValue("maxs", "{format_vector(maxs)}")')
    for item in entity.keyvalues():
        key_lower = item.key.lower()
        if key_lower in {"id", "classname", "angles", "origin", "mins", "maxs"}:
            continue
        if key_lower in SC_BREAKABLE_KEYS or key_lower.startswith("on"):
            lines.append(
                f'  {var_name}:SetKeyValue("{escape_lua_string(item.key)}", "{escape_lua_string(item.value)}")'
            )
    lines.extend(
        [
            f"  {var_name}:Spawn()",
            f"  {var_name}:Activate()",
            "end",
        ],
    )
    return lines


def render_lua(vmf_path: Path, entities: list[VmfBlock]) -> str:
    hook_name = re.sub(r"\W+", "_", vmf_path.stem)
    lines = [
        f"-- Generated from {vmf_path.name}.",
        "-- sc_breakable is a GLua-only func_breakable knockoff; VMF face materials are ignored.",
        "if not SERVER then return end",
        "",
        f'hook.Add("InitPostEntity", "SCBreakableConverter_{hook_name}", function()',
    ]
    used_names: set[str] = set()
    for index, entity in enumerate(entities):
        if index > 0:
            lines.append("")
        lines.extend(f"  {line}" if line else "" for line in render_entity(entity, used_names))
    lines.append("end)")
    return "\n".join(lines) + "\n"


def convert(vmf_path: Path) -> Path:
    root = VmfParser(read_text(vmf_path)).parse()
    entities = sc_breakable_entities(root)
    output_path = vmf_path.with_suffix(".lua")
    output_path.write_text(render_lua(vmf_path, entities), encoding="utf-8", newline="\n")
    print(f"Converted {len(entities)} sc_breakable entit{'y' if len(entities) == 1 else 'ies'} to {output_path}")
    return output_path


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert VMF sc_breakable entities to GLua.")
    parser.add_argument("vmf", type=Path, help="VMF file to convert.")
    args = parser.parse_args()
    convert(args.vmf)


if __name__ == "__main__":
    main()
