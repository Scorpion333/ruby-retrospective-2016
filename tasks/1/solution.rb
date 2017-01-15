def to_celsius(temperature, start_unit)
  conversions = {
    'C' => -> (degrees) { degrees },
    'K' => -> (degrees) { degrees - 273.15 },
    'F' => -> (degrees) { (degrees - 32) / 1.8 }
  }
  conversions[start_unit].call temperature
end

def from_celsius(temperature, result_unit)
  conversions = {
    'C' => -> (degrees) { degrees },
    'K' => -> (degrees) { degrees + 273.15 },
    'F' => -> (degrees) { degrees * 1.8 + 32 }
  }
  conversions[result_unit].call temperature
end

def convert_between_temperature_units(temperature, start_unit, result_unit)
  from_celsius(to_celsius(temperature, start_unit), result_unit)
end

def special_state_in_celsius(substance, state)
  state_temperatures = {
    'water' =>   {melting: 0,     boiling: 100},
    'ethanol' => {melting: -114,  boiling: 78.37},
    'gold' =>    {melting: 1064,  boiling: 2700},
    'silver' =>  {melting: 961.8, boiling: 2162},
    'copper' =>  {melting: 1085,  boiling: 2567}
  }
  state_temperatures[substance][state]
end

def melting_point_of_substance(substance, unit)
  from_celsius(special_state_in_celsius(substance, :melting), unit)
end

def boiling_point_of_substance(substance, unit)
  from_celsius(special_state_in_celsius(substance, :boiling), unit)
end