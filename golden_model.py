from pathlib import Path
import re


PROJECT_DIR = Path(__file__).resolve().parent
INPUT_FILE = PROJECT_DIR / "input.txt"
RTL_FILE = PROJECT_DIR / "FIR.sv"
OUTPUT_FILE = PROJECT_DIR / "ouput_python.txt"


def read_input_samples(path: Path) -> list[int]:
    samples = []
    with path.open("r", encoding="utf-8") as input_file:
        for line_number, line in enumerate(input_file, start=1):
            text = line.strip()
            if not text:
                continue
            try:
                samples.append(int(text))
            except ValueError as exc:
                raise ValueError(
                    f"Invalid input sample on line {line_number}: {text!r}"
                ) from exc
    return samples


def read_coefficients(path: Path) -> list[int]:
    source = path.read_text(encoding="utf-8")
    coefficient_block = re.search(
        r"parameter\s+logic\s+signed\s+\[.*?\]\s+Coeff\s*\[.*?\]\s*=\s*'\{(.*?)\};",
        source,
        flags=re.DOTALL,
    )
    if coefficient_block is None:
        raise ValueError(f"Could not find the Coeff array in {path}")

    values = [
        int(sign + digits)
        for sign, digits in re.findall(
            r"(-?)\s*16'sd(\d+)", coefficient_block.group(1)
        )
    ]
    if not values:
        raise ValueError(f"No coefficients found in {path}")
    return values


def fir_filter(samples: list[int], coefficients: list[int]) -> list[int]:
    delay_line = [0] * (len(coefficients) - 1)
    outputs = []

    for sample in samples:
        accumulator = sample * coefficients[0]
        for tap in range(1, len(coefficients)):
            accumulator += delay_line[tap - 1] * coefficients[tap]
        outputs.append(accumulator)

        # Match the RTL nonblocking delay-line update order.
        for index in range(len(delay_line) - 1, 0, -1):
            delay_line[index] = delay_line[index - 1]
        delay_line[0] = sample

    return outputs


def write_outputs(path: Path, outputs: list[int]) -> None:
    with path.open("w", encoding="utf-8", newline="\n") as output_file:
        for output in outputs:
            output_file.write(f"{output}\n")


if __name__ == "__main__":
    input_samples = read_input_samples(INPUT_FILE)
    coefficients = read_coefficients(RTL_FILE)
    filtered_outputs = fir_filter(input_samples, coefficients)
    write_outputs(OUTPUT_FILE, filtered_outputs)

    print(f"Read {len(input_samples)} input samples")
    print(f"Read {len(coefficients)} coefficients from {RTL_FILE.name}")
    print(f"Wrote {len(filtered_outputs)} outputs to {OUTPUT_FILE.name}")
