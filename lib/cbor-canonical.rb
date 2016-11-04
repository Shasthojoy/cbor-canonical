# -*- coding: utf-8 -*-

require "cbor" unless defined? CBOR

module CBOR
  module Canonical

    module Object_Canonical_CBOR
      def cbor_pre_canonicalize
        self
      end
      def to_canonical_cbor
        cbor_pre_canonicalize.to_cbor
      end
    end
    Object.send(:include, Object_Canonical_CBOR)

    module Array_Canonical_CBOR
      def cbor_pre_canonicalize
        map(&:cbor_pre_canonicalize)
      end
    end
    Array.send(:include, Array_Canonical_CBOR)

    module Hash_Canonical_CBOR
      def cbor_pre_canonicalize
        Hash[map {|k, v| cc = k.to_canonical_cbor
                         [cc.size, cc, k, v]}.
             sort.map{|s, cc, k, v| [k, v]}]
      end
    end
    Hash.send(:include, Hash_Canonical_CBOR)

    module Tagged_Canonical_CBOR
      def cbor_pre_canonicalize
        CBOR::Tagged.new(tag, value.cbor_pre_canonicalize)
      end
    end
    CBOR::Tagged.send(:include, Tagged_Canonical_CBOR)
  end
end

# and now for some tests...

[[1], [false], [10.3], [10.5], [Float::NAN],
 [{a: 1, b: [1, 2]}],
 [{aa: 1, b: 2}, {b: 2, aa: 1}],
 [CBOR::Tagged.new(4711, {aa: 1, b: 2}),
  CBOR::Tagged.new(4711, {b: 2, aa: 1})],
].each do |ex1, ex2, ex3|
  c1 = ex1.to_cbor
  cc1 = ex1.to_canonical_cbor
  # p cc1
  if ex2.nil?
    raise [:eq1, c1, cc1].inspect unless c1 == cc1
  else
    raise [:ne1, c1, cc1].inspect if c1 == cc1
    c2 = ex2.to_cbor
    raise [:eq2, cc1, c2].inspect unless cc1 == c2
    cc2 = ex2.to_canonical_cbor
    raise [:eq3, cc1, cc2].inspect unless cc1 == cc2
  end
end
