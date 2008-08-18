module Discogs
  class Contributor
    attr_accessor :name, :role
    def initialize(name, role)
      @name = name
      @role = role
    end

    def to_s
      name
    end
  end
end
