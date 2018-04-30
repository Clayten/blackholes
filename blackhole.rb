#!/usr/bin/env ruby
# https://github.com/olbrich/ruby-units/blob/master/lib/ruby_units/unit.rb

require 'physics'
require 'ruby-units'

class RubyUnits::Unit
#  def to_s f = nil ; "#{'%E' % scalar.to_f} #{units}" end
  if !instance_methods.include? :old_to_s
    alias old_to_s to_s
    def to_s n = '%.2E' ; old_to_s n ; end
  end
end

class Blackhole
  # https://arxiv.org/abs/0908.1803 - Blackhole Starships
  # https://en.wikipedia.org/wiki/Hawking_radiation
  # https://en.wikipedia.org/wiki/Gravitational_constant
  # http://xaonon.dyndns.org/hawking/hrcalc.js
  # https://www.vttoth.com/HAWKING/hrcalc.js
  # solar mass = 2e30kg

  def self.U s  ; Unit.new s end
  def self.G    ; U("#{Physics::FundamentalConstants.newtonian_constant_of_gravitation} m^3/kg*s^2") end # m^3*kg^-1*s^-2
  def self.C    ; U("#{Physics::FundamentalConstants.speed_of_light_in_vacuum} m/s") end
  def self.H    ; U("#{Physics::FundamentalConstants.plank_constant} W*s^2") end # J*s
  def self.Hbar ; self.H / Math::TAU end # J*s
  def U x  ; self.class.U x end
  def g    ; self.class.G end
  def c    ; self.class.C end
  def h    ; self.class.H    end
  def hbar ; self.class.Hbar end
  def pi  ; Math::PI end
  def ℎ ; h end
  def ℏ ; hbar end
  def 𝜋 ; pi end
  def 𝜏 ; tau end
  # FIXME add superscripts ² 

  def mass_scale= n ; @mass_scale = n ; @mass = mass.convert_to(mass_scale) end
  def mass_scale ; @mass_scale end
  def mass= mas
    mas = U(mas) if mas.is_a? String
    if mas.is_a? Unit
      mass_scale = mas.units
    else
      mas = U("#{mas} #{mass_scale}")
    end
    raise ArgumentError, "Improper argument - not mass. #{mas}" unless mas.kind == :mass
    p [:m=, mas]
    @mass = mas.convert_to(mas.base)
  end
  alias setmass mass=
  def mass ; @mass end

  attr_accessor :radius_scale
  def radius= rad
    raise ArgumentError, "Improper argument - not length. #{rad}" unless rad.kind == :length
    setmass(rad / (2 * g) * c**2)
    radius_scale = rad.units
  end
  def radius ; (mass * 2 * g / c**2).convert_to(radius_scale) end

  attr_accessor :area_scale
  def area= ar
    raise ArgumentError, "Improper argument - not area. #{ar}" unless ar.kind == :area
    raise
  end
  def area ; (4 * pi * radius**2).convert_to(area_scale) end

  attr_accessor :gravity_scale
  def gravity= grav
    raise ArgumentError, "Improper argument - not acceleration. #{grav}" unless grav.kind == :acceleration
    raise
  end
  def gravity ; (1 / mass * c**4 / (4 * g)).convert_to(gravity_scale) end

  attr_accessor :luminosity_scale
  def luminosity= lum
    raise ArgumentError, "Improper argument - not power. #{lum}" unless lum.kind == :power
    raise
  end
  def luminosity ; ((1 / mass**2) * ((hbar * c**6) / (15360 * pi * g**2))) end

  attr_accessor :lifetime_scale
  def lifetime= lif
    raise ArgumentError, "Improper argument - not time. #{lif}" unless lif.kind == :time
    raise
  end
  def lifetime ; (mass**3 * ((5120 * pi * g**2) / (hbar * c**4))).convert_to(lifetime_scale) end

  attr_accessor :energy_scale
  def energy= energ
    raise ArgumentError, "Improper argument - not energy. #{energ}" unless energ.kind == :energy
    setmass(energ.convert_to('J') / c**2)
  end
  def energy ; (mass * c**2).convert_to(energy_scale) end

  def entropy= n ; raise end # FIXME
  def entropy_unitcorrection ; '1 kg*m^2/W*s^3' end
  def entropy ; (mass**2 * ((4 * pi * g) / (hbar * c / Math.log(10)))) / entropy_unitcorrection end # FIXME Wrong number and units

  def to_s ; "(mass: #{mass}, radius: #{radius}, area: #{area}, gravity: #{gravity}, energy: #{energy}, luminosity: #{luminosity}, lifetime: #{lifetime})" end

  def inspect ; "<Blackhole:0x#{object_id.to_s 16} #{to_s}>" end

  def age_by n # days
    # returns energy released, decrements mass
  end

  def initialize mass # kg
    self.mass= mass
    @mass_scale = 'kg'
    @radius_scale = 'm'
    @area_scale = 'm^2'
    @gravity_scale = 'm/s^2'
    @luminosity_scale = 'W'
    @lifetime_scale = 's'
    @energy_scale = 'J'
  end
end

