# `cbor-canonical` gem

Use with the [`cbor`][cbor-ruby] gem (or with `cbor-pure`, which is a
part of the [`cbor-diag`][cbor-diag] gem) to
add a `to_canonical_cbor` method on objects.
Requires `to_cbor` to already be mostly canonical (as it is for the
above two [CBOR] implementations), just adds canonical ordering of maps
for completeness.

```ruby
require 'cbor-canonical'

ex1 = {aa: 1, b: 2}

p CBOR.decode(ex1.to_cbor)
# {"aa"=>1, "b"=>2}

p CBOR.decode(ex1.to_canonical_cbor)
# {"b"=>2, "aa"=>1}
```

[cbor-ruby]: https://github.com/cabo/cbor-ruby
[cbor-diag]: https://github.com/cabo/cbor-diag
[CBOR]: http://cbor.io
