# Integer To Binary Converter (32-bits)
This program converts a 32-bit unsigned integer into its binary representation.

## Functionality
```mermaid
flowchart TD;
    A[Calculate amount of bits] --> B[Allocate stack];
    B --> C[Perform division];
    C --> D[Store the remainder in stack];
    D --> E[Reset division parameters && Dividend = Quotient];
    E --> F{Quotient == 0?};
    F -- NO --> C;
    F -- YES --> G[Print binary result];
 ```

### Calculating the amount of bits represented
The formula to find the number of bits represented by a number is: 
![equation](https://latex.codecogs.com/gif.latex?%5Cdpi%7B100%7D%20%5Cbg_white%20%5Clarge%20%5Clfloor%7B%5C%28log_%7B2%7D%20n%29%7D%5Crfloor%20&plus;%201).

For this, a recursive log-base-2 function was implemented that only finds the integer result without the fractional part.
The result of this log calculation added with 1, will be the amount of bits the number will have. This number also determines
the allocation size of the stack pointer.

### Division by 2
A slow restoring division algorithm was used to sequentially divide by two.

```mermaid
flowchart TD;
    A[Start] --> B[Remainder = Remainder - Divisor];
    B --> C{Test Remainder};
    C -- Remainder >= 0 --> D[Quotient << 1 && Set least significant bit = 1];
    C -- Remainder < 0 --> E[Restore: Remainder = Remainder + Divisor];
    E --> F[Quotient << 1 && Set least significant bit = 0];
    D --> G[Divisor >> 1];
    F --> G;
    G --> H{32 repetitions?};
    H -- Yes --> I[Finish];
    H-- No --> A;
```
----
## Quickstart:
### Requirements
- VSCode
- RISC-V Venus Simulator Extension (VSCode)

### Steps
1. Create a project directory and clone the project (e.g., mkdir ~/Projects).


2. Go to the project directory (e.g., cd ~/Projects).


3. `git clone https://github.com/PaimonCodes/RISCV32-32-bit-Decimal-To-Binary-Converter`


4. Choose the integer to be converted and edit the integer data.
https://github.com/PaimonCodes/RISCV32-32-bit-Integer-To-Binary-Converter/blob/eacb707dce7f64c126272bbb78486e036e18508a/IntegerToBinary.s#L7-L8


5. Press F5 or go to `Run` and `Start Debugging`. The binary output will be in the Venus Terminal `Terminal - New Terminal`.
