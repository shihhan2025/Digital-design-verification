# FIFO
- RTL Design
- SystemVerilog Testbench
- UVM Environment
- Assertions
- Functional Coverage

# FIFO Spec.
### FIFO Type
Synchronous FIFO

### Clock
Single Clock

### Reset
Active Low Reset

### Data Width
8 bits

### Depth
16 entries

### Interface
wr_en
rd_en
wdata
rdata
full
empty

### Operation
###### Write when
wr_en == 1 && full == 0
###### Read when
rd_en == 1 && empty == 0
###### Overflow
wr_en ==1 && full==1
###### Underflow
rd_en==1 && empty==1
