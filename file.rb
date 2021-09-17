class Car
    attr_reader :year, :make, :model, :trim
  
    def initialize(year, make, model, trim)
      @year  = year
      @make  = make
      @model = model
      @trim  = trim
    end
  
    def normalize
      normalize_year
      normalize_make
      normalize_model
      normalize_trim
  
      { year: @year, make: @make, model: @model, trim: @trim }
    end
  
    def normalize_year
      @year = @year.to_i if @year.to_i.between?(1900, Time.now.year + 2)
    end
  
    def normalize_make
      case @make
      when 'fo', 'ford'
        @make = 'Ford'
      when 'Chev'
        @make = 'Chevrolet'
      end
    end
  
    def normalize_model
      models = @model.split ' '
      @trim = models[1].upcase if models.length > 1
      @model = models[0].capitalize unless models[0] == 'foo'
    end
  
    def normalize_trim
      case @trim
      when 'blank' then @trim = nil
      when 'st' then @trim = 'ST'
      end
    end
  end
  
  def normalize_data(data)
    car = Car.new(data[:year], data[:make], data[:model], data[:trim])
    car.normalize
  end
  
  examples = [
    [{ year: '2018', make: 'fo', model: 'focus', trim: 'blank' },
     { year: 2018, make: 'Ford', model: 'Focus', trim: nil }],
    [{ year: '200', make: 'blah', model: 'foo', trim: 'bar' },
     { year: '200', make: 'blah', model: 'foo', trim: 'bar' }],
    [{ year: '1999', make: 'Chev', model: 'IMPALA', trim: 'st' },
     { year: 1999, make: 'Chevrolet', model: 'Impala', trim: 'ST' }],
    [{ year: '2000', make: 'ford', model: 'focus se', trim: '' },
     { year: 2000, make: 'Ford', model: 'Focus', trim: 'SE' }]
  ]
  
  examples.each_with_index do |(input, expected_output), index|
    if (output = normalize_data(input)) == expected_output
      puts "Example #{index + 1} passed!"
    else
      puts "Example #{index + 1} failed,
            Expected: #{expected_output.inspect}
            Got:      #{output.inspect}"
    end
  end
          