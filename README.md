# cbor-canonical gem

Use with `cbor` (or `cbor-pure`, which is a part of `cbor-diag`) to
also get a `to_canonical_cbor` method on objects.
Requires `to_cbor` to already be mostly canonical (as it is for the
above two CBOR implementations), adds canonical ordering of maps for
completeness.

```ruby
require 'cbor-canonical'

ex1 = {aa: 1, b: 2}

p CBOR.decode(ex1.to_cbor)
# {"aa"=>1, "b"=>2}

p CBOR.decode(ex1.to_canonical_cbor)
# {"b"=>2, "aa"=>1}
```
