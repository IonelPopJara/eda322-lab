# eda322-lab
Source files for the course EDA322: Digital Design at Chalmers


## Testing

### Testing the proc_bus
```
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
```