# frozen_string_literal: true

# Module for creating variants. Include in models that need it
module CreateVariant
  extend ActiveSupport::Concern

  included do
    def create_variants
      %w[HD SD].each do |variant|
        variants.create!(quality: variant)
      end
    end
  end
end
