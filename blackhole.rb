#!/usr/bin/env ruby
# https://github.com/olbrich/ruby-units/blob/master/lib/ruby_units/unit.rb
# https://github.com/jeffmcfadden/physics/blob/master/lib/physics/fundamental_constants.rb

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
  # https://en.wikipedia.org/wiki/Black_hole_thermodynamics
  # https://en.wikipedia.org/wiki/Hawking_radiation
  # https://en.wikipedia.org/wiki/Gravitational_constant
  # http://xaonon.dyndns.org/hawking/hrcalc.js
  # https://www.vttoth.com/CMS/physics-notes/311-hawking-radiation-calculator
  # https://www.vttoth.com/HAWKING/hrcalc.js
  # solar mass = 2e30kg

  def self.U s, u = nil ; Unit.new s, u end
  def self.R a, b       ; Rational a, b end
  def self.G      ; U("#{Physics::FundamentalConstants.newtonian_constant_of_gravitation} m^3/kg*s^2") end # m^3*kg^-1*s^-2
  def self.C      ; U("#{Physics::FundamentalConstants.speed_of_light_in_vacuum} m/s") end
  def self.H      ; U("#{Physics::FundamentalConstants.plank_constant} W*s^2") end # J*s
  def self.Hbar   ; self.H / Math::TAU end # J*s
  def R a, b ; self.class.R a, b end
  def U x    ; self.class.U x end
  def g      ; self.class.G end
  def c      ; self.class.C end
  def h      ; self.class.H    end
  def hbar   ; self.class.Hbar end
  def pi ; Math::PI end
  def infinity ; 1/0.0 end # Defined for floats
  def ℎ ; h end
  def ℏ ; hbar end
  def 𝜋 ; pi end
  def 𝜏 ; tau end
  def ∞ ; infinity end
  # FIXME add superscripts ² 

  def base_mass_units ; 'kg' end
  def mass_units ; @mass_units ||= base_mass_units end
  def set_mass_units u
    raise ArgumentError, "Improper argument - not mass. #{u}" unless U(u).kind == :mass
    @mass_units = u
    @mass = mass.convert_to(mass_units) if mass
  end
  def mass= mas, base_units = false
    mas = U(mas) if mas.is_a? String
    if mas.is_a?(Unit) && mas.kind != :unitless
      set_mass_units mas.units
    else
      if base_units
        mas = U("#{mas} #{base_mass_units}").to(mass_units)
      else
        mas = U("#{mas} #{mass_units}")
      end
    end
    raise ArgumentError, "Mass cannot be negative" if mas < 0
    raise ArgumentError, "Mass cannot be infinite" if mas.scalar == infinity
    @mass = mas
  end
  alias setmass mass=
  def mass ; @mass end

  def base_radius_units ; 'm' end
  def radius_units ; @radius_units ||= base_radius_units end
  def set_radius_units u
    raise ArgumentError, "Improper argument - not length. #{u}" unless U(u).kind == :length
    @radius_units = u
  end
  def radius= rad
    rad = U(rad) if rad.is_a? String
    set_radius_units rad.units
    setmass((rad.convert_to(base_radius_units) / (2 * g) * c**2).scalar.to_f, true)
  end
  def radius ; (mass * 2 * g / c**2).convert_to(radius_units) end

  def base_area_units ; 'm^2' end
  def area_units ; @area_units ||= base_area_units end
  def set_area_units u
    raise ArgumentError, "Improper argument - not area. #{u}" unless U(u).kind == :area
    @area_units = u
  end
  def area= ar
    ar = U(ar) if ar.is_a? String
    set_area_units ar.units
    setmass((Math.sqrt(ar.convert_to(base_area_units) / (16 * pi * g**2) * (c**4))).scalar.to_f, true)
  end
  def area ; (4 * pi * radius**2).convert_to(area_units) end

  def base_gravity_units ; 'm/s^2' end
  def gravity_units ; @gravity_units ||= base_gravity_units end
  def set_gravity_units u
    raise ArgumentError, "Improper argument - not acceleration. #{u}" unless U(u).kind == :acceleration
    @gravity_units = u
  end
  def gravity= grav
    grav = U(grav) if grav.is_a? String
    set_gravity_units grav.units
    return setmass(0) if grav <= 0
    setmass((1 / (grav.convert_to(base_gravity_units) / c**4 * (4 * g))).scalar.to_f, true)
  end
  def gravity
    return U("0 #{base_gravity_units}") if mass.zero?
    (1 / mass * c**4 / (4 * g)).convert_to(gravity_units)
  end

  def base_energy_units ; 'J' end
  def energy_units ; @energy_units ||= base_energy_units end
  def set_energy_units u
    raise ArgumentError, "Improper argument - not energy. #{u}" unless U(u).kind == :energy
    @energy_units = u
  end
  def energy= energ
    energ = U(energ) if energ.is_a? String
    set_energy_units energ.units
    setmass((energ.convert_to(base_energy_units) / c**2).scalar.to_f, true)
  end
  def energy ; (mass * c**2).convert_to(energy_units) end

  def base_luminosity_units ; 'W' end
  def luminosity_units ; @luminosity_units ||= base_luminosity_units end
  def set_luminosity_units u
    raise ArgumentError, "Improper argument - not power. #{u}" unless U(u).kind == :power
    @luminosity_units = u
  end
  def luminosity= lum
    lum = U(lum) if lum.is_a? String
    set_luminosity_units lum.units
    return setmass(0) if lum <= 0
    setmass((1 / Math.sqrt(lum.convert_to(base_luminosity_units) / (hbar * c**6) * (15360 * pi * g**2))).scalar.to_f, true)
  end
  def luminosity
    return U("0 #{base_luminosity_units}") if mass.zero?
    ((1 / mass**2) * ((hbar * c**6) / (15360 * pi * g**2))).convert_to(luminosity_units)
  end

  def base_lifetime_units ; 's' end
  def lifetime_units ; @lifetime_units ||= base_lifetime_units end
  def set_lifetime_units u
    raise ArgumentError, "Improper argument - not time. #{u}" unless U(u).kind == :time
    @lifetime_units = u
  end
  def lifetime= lif
    lif = U(lif) if lif.is_a? String
    set_lifetime_units lif.units
    return setmass(0) if lif <= 0
    setmass(((lif.convert_to(base_lifetime_units) / 5120 / pi / g**2 * hbar * c**4).base.scalar ** R(1,3)).to_f, true)
  end
  def lifetime ; (mass**3 * ((5120 * pi * g**2) / (hbar * c**4))).convert_to(lifetime_units) end

  def entropy= ent
    ent = U(ent) if ent.is_a? String
    raise ArgumentError, "Entropy is unitless" unless ent.units.empty?
    setmass(Math.sqrt(ent / (4 * pi * g) * (hbar * c)).scalar)
  end
  def entropy ; U((mass**2 * 4 * pi * g / hbar / c).scalar.to_f) end

  def to_s ; "(Mass: #{mass}, Radius: #{radius}, Area: #{area}, Gravity: #{gravity}, Entropy: #{entropy}, Energy: #{energy}, Luminosity: #{luminosity}, Lifetime: #{lifetime})" end

  def inspect ; "<Blackhole:0x#{object_id.to_s 16} #{to_s}>" end

  def age_by n # days
    n = U(n) unless n.is_a? Unit
    raise ArgumentError, "Needs to be time: '#{n}' -> '#{n.kind}'" unless n.kind == :time
    e = energy
    self.lifetime = lifetime - n
    de = e - energy
  end

  def initialize value, field = :mass
    fieldname = "#{field}="
    raise "Unknown field #{field}" unless methods.include? fieldname
    self.send(fieldname, value)
  end
end

