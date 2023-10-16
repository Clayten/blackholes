# Blackhole Calculator

Simulate a [black hole](https://en.wikipedia.org/wiki/Black_hole). Set any variable, see how the others change. Supports all standard units.

## About

Blackhole Calculator was created to give flexible (set any variable, in any unit) answers to general questions such as the amount of hawking radiation or lifetime of a blackhole of any mass.

It does not support the complex (and more real-world) cases of charged or spinning blackholes.

Non-charged, non-rotating black holes can be described with a single value, their mass. Blackhole Calculator lets you set derived values (lifetime, radius, etc) and it internally sets the mass which makes that value correct.

The project was intended as a backend for a learning-physics website and the source code for each value would be displayed alongside a more mathematical render of the equation. For simplicity the values are all calculated in relation to mass and for teaching reasons, in a programming idiom.

## Sources

* http://archive.today/2018.08.10-100540/http://xaonon.dyndns.org/hawking/
* https://www.vttoth.com/CMS/physics-notes/311-hawking-radiation-calculator

Viktor Toth uses a different (probably better) formula for blackhole lifetime. This calculator doesn't include their constant factor of 1.8083 because that is based on a more complex understanding of a blackhole than this simple model. I'll revisit this later with many of the other derived fields they support.

## Prerequisites

Requires Ruby and the gems ruby-units and physics, also benefits from pry or irb.

## Usage

Create an object representing a blackhole - defaults to expecting mass
```ruby
bh = Blackhole.new('1e15kg')
=> <Blackhole:0x2e4 (Mass: 1.00E+15 kg, Radius: 1.49E-12 m, Area: 2.77E-23 m^2, Gravity: 3.03E+28 m/s^2, Entropy: 2.65E+46, Energy: 8.99E+31 J, Luminosity: 3.56E+02 W, Lifetime: 8.41E+28 s)>
```

Change the units for a given variable leaving the values unchanged
```ruby
bh.set_lifetime_units 'y'
=> "y"

bh
=> <Blackhole:0x334 (Mass: 1.00E+15 kg, Radius: 1.49E-12 m, Area: 2.77E-23 m^2, Gravity: 3.03E+28 m/s^2, Entropy: 2.65E+46, Energy: 8.99E+31 J, Luminosity: 3.56E+02 W, Lifetime: 2.67E+21 y)>
```

Set a variable
```ruby
bh.lifetime = '100 y'
=> "100 y"

bh
=> <Blackhole:0x334 (Mass: 3.35E+08 kg, Radius: 4.97E-19 m, Area: 3.11E-36 m^2, Gravity: 9.04E+34 m/s^2, Entropy: 2.97E+33, Energy: 3.01E+25 J, Luminosity: 3.18E+15 W, Lifetime: 1.00E+02 y)>
```

Change a variable
```ruby
bh.luminosity *= 10
=> 3.18E+16 W

bh
=> <Blackhole:0x334 (Mass: 1.06E+08 kg, Radius: 1.57E-19 m, Area: 3.11E-37 m^2, Gravity: 2.86E+35 m/s^2, Entropy: 2.97E+32, Energy: 9.51E+24 J, Luminosity: 3.18E+16 W, Lifetime: 3.16E+00 y)>
```

Supports all standard units for setting and displaying
```ruby
bh.set_mass_units 'ounce'
=> 3.73E+09 oz

bh
=> <Blackhole:0x334 (Mass: 3.73E+09 oz, Radius: 1.57E-19 m, Area: 3.11E-37 m^2, Gravity: 2.86E+35 m/s^2, Entropy: 3.70E+35, Energy: 9.51E+24 J, Luminosity: 3.18E+16 W, Lifetime: 3.16E+00 y)>
```

Catches improper units
```ruby
bh.set_mass '1.21 GW'
ArgumentError: Improper argument - not mass. Value is power
```

Initialize with any of the variables by specifying in the constructor
```ruby
bh = Blackhole.new('1.21 GW', :luminosity)
=> <Blackhole:0x3e8 (Mass: 5.43E+11 kg, Radius: 8.06E-16 m, Area: 8.16E-30 m^2, Gravity: 5.58E+31 m/s^2, Entropy: 7.81E+39, Energy: 4.88E+28 J, Luminosity: 1.21E+00 GW, Lifetime: 1.34E+19 s)>
```

## License

AGPLv2
