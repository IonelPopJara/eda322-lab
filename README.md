# eda322-lab

Source files for the course EDA322: Digital Design at Chalmers

## Testing

### Testing the registry

```bash
force clk 0 0, 1 50ns -repeat 100s
force rstn 0 0ns
force en 0 0ns 
force d "11110000" 0ns
force q "00000000" 0ns
force en 1 200ns
force en 0 300ns 
force d "00001111" 300ns
force en 1 500ns
run 1000ns
```

### Testing the proc_bus

```bash
force imDataOut "00001111"
force dmDataOut "11110000"
force accOut "11001100"
force extIn "00110011"
force busSel "0000" 0ns
force busSel "0001" 100ns
force busSel "0010" 200ns
force busSel "0100" 300ns
force busSel "1000" 400ns
force busSel "1001" 500ns
run 1000ns
```
