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
  # http://xaonon.dyndns.org/hawking/hrcalc.js
  # https://www.vttoth.com/HAWKING/hrcalc.js
  # solar mass = 2e30kg

  def self.G    ; Unit.new("#{Physics::FundamentalConstants.newtonian_constant_of_gravitation} m^3/kg*s^2") end # m^3*kg^-1*s^-2
  def self.C    ; Unit.new("#{Physics::FundamentalConstants.speed_of_light_in_vacuum} m/s") end
  def self.H    ; Unit.new("#{Physics::FundamentalConstants.plank_constant} W*s^2") end # J*s
  def self.Hbar ; self.H / Math::TAU end # J*s
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
    p [:m1=, mas]
    mas = Unit.new mas if mas.is_a? String
    if mas.is_a? Unit
      mass_scale = mas.units
    else
      mas = Unit.new "#{mas} #{mass_scale}"
    end
    p [:m2=, mas]
    @mass = mas
  end
  alias setmass mass=
  def mass ; @mass end

  attr_accessor :radius_scale
  def radius= rad ; setmass(rad / (2 * g) * c**2) ; radius_scale = rad.units end # FIXME
  def radius ; p [:r, :m, @mass] ; (mass * 2 * g / c**2).convert_to(radius_scale) end

  def area= n ; end # FIXME
  def area ; 4 * pi * radius**2 end

  def gravity= n ; end # FIXME
  def gravity ; 1 / mass * c**4 / (4 * g) end

  def entropy= n ; end # FIXME
  def entropy ; (mass**2 * ((4 * pi * g) / (hbar * c / Math.log(10)))) / '1 kg*m^2/W*s^3' end # FIXME Wrong number and units

  def luminosity= n ; end # FIXME
  def luminosity ; ((1 / mass**2) * ((hbar * c**6) / (15360 * pi * g**2))) end

  def lifetime= n ; end # FIXME
  def lifetime_unitcorrection ; 1 end # '1 kg*m^2/W*s^3' end
  def lifetime ; (mass**3 * ((5120 * pi * g**2) / (hbar * c**4))) / lifetime_unitcorrection end # FIXME Units all wrong without compensation

  def total_energy= n ; end # FIXME
  def total_energy ; (mass * c**2).convert_to 'J' end

  def to_s ; "(mass: #{mass} radius: #{radius} area: #{area} gravity: #{gravity} entropy: #{entropy} luminosity: #{luminosity} lifetime: #{lifetime})" end

  def inspect ; "<Blackhole:0x#{object_id.to_s 16} #{to_s}>" end

  def age_by n # days
    # returns energy released, decrements mass
  end

  def initialize mass # kg
    self.mass= mass
    @radius_scale = 'm'
    @mass_scale = 'kg'
  end
end

