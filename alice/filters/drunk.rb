module Filters

  class Drunk

    def process(text)
      if Util::Randomizer.one_chance_in(4)
        to_process = text.split
        positions = to_process.sample(to_process.length / 2).map{|word| to_process.index(word)}.sort
        to_process.inject([]) do |a, word|
          if positions.include?(a.length)
            a << filtered(word)
          else
            a << word
          end
          a
        end.join(' ')
      else
        text
      end
    end

    def filtered(text)
      return text.split.map{|word| word + word[-1] * rand(2)}.join(" ")
    end

  end

end
