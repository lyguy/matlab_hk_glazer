classdef EntryGetter
  properties
    lines
  end %properties
    
  methods
    function eg = EntryGetter(str)
      %Construct a cell array from the lines/words in the string
      
      l = strread(str, '%s', 'delimiter','\n');
      for ii = 1:length(l)
        eg.lines{ii} = strread(l{ii}, '%s', 'delimiter', ' ');
      end
    end
    
    function s = linePos(self, line, word)
      %Return the line,pos word in the initialization string
      s = self.lines{line}{word};
    end
  end %methods
end
        
