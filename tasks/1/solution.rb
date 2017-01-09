def convert_between_temperature_units(degrees, start_unit, result_unit)
  if start_unit == result_unit
    degrees
  
  elsif start_unit == 'C' && result_unit == 'K'
    degrees + 273.15
  
  elsif start_unit == 'K' && result_unit == 'C'
    degrees - 273.15
  
  elsif start_unit == 'C' && result_unit == 'F'
    degrees * 9.to_f / 5 + 32
  
  elsif start_unit == 'F' && result_unit == 'C'
    (degrees - 32) * 5.to_f / 9
  
  elsif start_unit == 'K' && result_unit == 'F'
    (degrees - 273.15) * 9.to_f / 5 + 32
  
  elsif start_unit == 'F' && result_unit == 'K'
    (degrees - 32) * 5.to_f / 9 + 273.15
  
  end
end

def melting_point_of_substance(substance, unit)
  
  celsius_melting_points = {
    'water' => 0,
    'ethanol' => -114,
    'gold' => 1064,
    'silver' => 961.8,
    'copper' => 1085
  }
  convert_between_temperature_units(celsius_melting_points[substance], 'C', unit)
end

def boiling_point_of_substance(substance, unit)

  celsius_boiling_points = {
    'water' => 100,
    'ethanol' => 78.37,
    'gold' => 2700,
    'silver' => 2162,
    'copper' => 2567
  }
  convert_between_temperature_units(celsius_boiling_points[substance], 'C', unit)
end