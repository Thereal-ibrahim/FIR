from pathlib import Path


COMPARE_COUNT = 58_400
RTL_OUTPUT = Path(__file__).with_name("output.txt")
PYTHON_OUTPUT = Path(__file__).with_name("ouput_python.txt")
REPORT_FILE = Path(__file__).with_name("output_comparison.txt")


def read_values(path: Path) -> list[int]:
    values: list[int] = []
    with path.open("r", encoding="utf-8") as input_file:
        for line_number, line in enumerate(input_file, start=1):
            text = line.strip()
            if not text:
                continue
            try:
                values.append(int(text))
            except ValueError as exc:
                raise ValueError(
                    f"Invalid integer in {path.name} on line {line_number}: {text!r}"
                ) from exc
    return values


def compare_outputs() -> list[str]:
    rtl_values = read_values(RTL_OUTPUT)
    python_values = read_values(PYTHON_OUTPUT)

    if len(rtl_values) < COMPARE_COUNT:
        raise ValueError(
            f"{RTL_OUTPUT.name} contains {len(rtl_values)} values; "
            f"expected at least {COMPARE_COUNT}"
        )
    if len(python_values) < COMPARE_COUNT:
        raise ValueError(
            f"{PYTHON_OUTPUT.name} contains {len(python_values)} values; "
            f"expected at least {COMPARE_COUNT}"
        )

    mismatches = [
        f"Line {line_number}: output.txt={rtl_value}, "
        f"ouput_python.txt={python_value}"
        for line_number, (rtl_value, python_value) in enumerate(
            zip(rtl_values[:COMPARE_COUNT], python_values[:COMPARE_COUNT]),
            start=1,
        )
        if rtl_value != python_value
    ]

    REPORT_FILE.write_text(
        "\n".join(mismatches) + ("\n" if mismatches else ""),
        encoding="utf-8",
    )
    return mismatches


if __name__ == "__main__":
    mismatches = compare_outputs()
    print(f"Compared {COMPARE_COUNT} values.")
    print(f"Mismatches: {len(mismatches)}")
    print(f"Report: {REPORT_FILE.name}")
    if not mismatches:
        print("All compared values are equal.")
