require 'svmkit/base/base_estimator'
require 'svmkit/base/transformer'

module SVMKit
  # This module consists of the classes that perform preprocessings.
  module Preprocessing
    # Normalize samples by centering and scaling to unit variance.
    #
    # @example
    #   normalizer = SVMKit::Preprocessing::StandardScaler.new
    #   new_training_samples = normalizer.fit_transform(training_samples)
    #   new_testing_samples = normalizer.transform(testing_samples)
    class StandardScaler
      include Base::BaseEstimator
      include Base::Transformer

      # Return the vector consists of the mean value for each feature.
      # @return [NMatrix] (shape: [1, n_features])
      attr_reader :mean_vec

      # Return the vector consists of the standard deviation for each feature.
      # @return [NMatrix] (shape: [1, n_features])
      attr_reader :std_vec

      # Create a new normalizer for centering and scaling to unit variance.
      #
      # @overload new() -> StandardScaler
      def initialize(_params = {})
        @mean_vec = nil
        @std_vec = nil
      end

      # Calculate the mean value and standard deviation of each feature for scaling.
      #
      # @overload fit(x) -> StandardScaler
      #
      # @param x [NMatrix] (shape: [n_samples, n_features])
      #   The samples to calculate the mean values and standard deviations.
      # @return [StandardScaler]
      def fit(x, _y = nil)
        @mean_vec = x.mean(0)
        @std_vec = x.std(0)
        self
      end

      # Calculate the mean values and standard deviations, and then normalize samples using them.
      #
      # @overload fit_transform(x) -> NMatrix
      #
      # @param x [NMatrix] (shape: [n_samples, n_features])
      #   The samples to calculate the mean values and standard deviations.
      # @return [NMatrix] The scaled samples.
      def fit_transform(x, _y = nil)
        fit(x).transform(x)
      end

      # Perform standardization the given samples.
      #
      # @param x [NMatrix] (shape: [n_samples, n_features]) The samples to be scaled.
      # @return [NMatrix] The scaled samples.
      def transform(x)
        n_samples, = x.shape
        (x - @mean_vec.repeat(n_samples, 0)) / @std_vec.repeat(n_samples, 0)
      end

      # Dump marshal data.
      # @return [Hash] The marshal data about StandardScaler.
      def marshal_dump
        { mean_vec: Utils.dump_nmatrix(@mean_vec),
          std_vec: Utils.dump_nmatrix(@std_vec) }
      end

      # Load marshal data.
      # @return [nil]
      def marshal_load(obj)
        @mean_vec = Utils.restore_nmatrix(obj[:mean_vec])
        @std_vec = Utils.restore_nmatrix(obj[:std_vec])
        nil
      end
    end
  end
end