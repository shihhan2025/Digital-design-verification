## FIFO
- RTL Design
- SystemVerilog Testbench
- UVM Environment
- Assertions
- Functional Coverage

## FIFO Spec.
| Feature | Value | Note |
| :--- | :--- | :--- |
| **FIFO Type** | Synchronous FIFO | |
| **Clock** | Single Clock | |
| **Reset** | Active Low Reset | `rst_n` |
| **Data Width** | 8 bits | |
| **Depth** | 16 entries | |

### Interface
- `wr_en`, `rd_en`
- `wdata`, `rdata`
- `full`, `empty`

### Operation Rules
* **Write**: `wr_en == 1 && full == 0`
* **Read**: `rd_en == 1 && empty == 0`
* **Overflow**: `wr_en == 1 && full == 1`
* **Underflow**: `rd_en == 1 && empty == 1`

## Verification Plan
| Test | Description |
|:---|:---|
| **Reset** | Verify FIFO reset behavior |
| **Write** | Verify write operation |
| **Read** | Verify read operation |
| **Full** | Verify full flag |
| **Empty** | Verify empty flag |
| **Overflow** | Verify overflow handling |
| **Underflow** | Verify underflow handling |
| **Simultaneous RW** | Verify read/write in same cycle |
| **Wrap-around Test** | Verify pointer wrap-around |

