classdef EntryGetter
%  EntryGetter
%
%  Object to take in a string, delimited by newlines, and allow
%  one to look up words in the string based upon line number
%  and position in the line.
%
  properties
    lines % array of lines taken from originating string.
  end %properties
    
  methods
    function eg = EntryGetter(str)
      % constrctor function
      %Construct a cell array from the lines/words in the string
      
      l = strread(str, '%s', 'delimiter','\n');
      for ii = 1:length(l)
        eg.lines{ii} = strread(l{ii}, '%s');
      end
    end
    
    function s = linePos(self, line, word)
      %Return the line,pos word in the initialization string
      % e.g. linePos(5, 2) returns the second word in the fifth
      % line of str.
      s = self.lines{line}{word};
    end
  end %methods
end
        
