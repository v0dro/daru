module Daru
  module Category
    attr_accessor :coding_scheme, :base_category

    def initialize_catogory data, opts={}
      @type = :category

      # Create a hash to map each category to positional indexes
      categories = data.each_with_index.group_by(&:first)
      @cat_hash = categories.map { |cat, group| [cat, group.map(&:last)] }.to_h

      # Map each category to a unique integer for effective storage in @array
      map_cat_int = categories.keys.each_with_index.to_h

      # Inverse mapping of map_cat_int
      @map_int_cat = map_cat_int.invert

      # To link every instance to its category,
      # it stores integer for every instance representing its category
      @array = map_cat_int.values_at(*data)

      # Specify if the categories are ordered or not.
      # By default its unordered
      @order = opts[:order] || false

      # The coding scheme to code with. Default is dummy coding.
      @coding_scheme = :dummy

      # Base category which won't be present in the coding
      @base_category = @cat_hash.keys.first

      # Stores the name of the vector
      @name = opts[:name]
    end

    def each
      return enum_for(:each) unless block_given?
      @array.each { |pos| yield @map_int_cat[pos] }
      self
    end

    def to_a
      each.to_a
    end

    def size
      @array.size
    end

    def ordered?
      @order
    end

    def category
      @cat_hash.keys
    end

    def contrast_code full=false
      send("#{coding_scheme}_coding".to_sym, full)
    end

    private

    def dummy_coding full
      categories = @cat_hash.keys
      categories.shift unless full

      df = categories.map do |category|
        code_to_binary @cat_hash[category]
      end

      Daru::DataFrame.new df,
        index: @index,
        order: create_names(categories)
    end

    def code_to_binary positions
      binary = Array.new(size, 0)
      positions.map { |pos| binary[pos] = 1 }
      binary
    end

    def create_names categories
      categories.map { |cat| "#{name}_#{cat}" }
    end
  end
end
