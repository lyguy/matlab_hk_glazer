# Glazer 0.0.2

This is a part of the Hock Melt Model: a tool to import and output valid input.txt files into MATLAB Maps.

## Installation
Copy the folder ```+glazer``` into your MATLAB path.


## Useage
- **Input.txt to Map**: do in MATLAB:

```matlab
>> s = fileread('input.txt');
>> config = glazer.degreeToMaps(s);
```
- **Map to Input.txt**: do

```matlab
>> ss = glazer.MapsToDegree(config);
>> f = fopen('newInput.txt', 'w');
>> fprintf(f, '%s', ss); 
```

## License
MIT
