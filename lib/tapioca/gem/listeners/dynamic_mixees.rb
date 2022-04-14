# typed: strict
# frozen_string_literal: true

module Tapioca
  module Gem
    module Listeners
      class DynamicMixees < Base
        extend T::Sig

        include Runtime::Reflection

        private

        sig { override.params(event: ScopeNodeAdded).void }
        def on_scope(event)
          constant = event.constant

          Tapioca::Runtime::Trackers::Mixin.constants_with_mixin(constant).each do |entry|
            _, subentry = entry

            next if subentry.empty?

            subentry.each do |mixee, _|
              name = @pipeline.name_of(mixee)
              @pipeline.push_constant(name, mixee) if name
            end
          end
        end
      end
    end
  end
end
