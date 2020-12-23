## Another old-friend: List processing
- Empty list: `null`
- Cons constructor: `cons`
- Access head of list:`car`
- Access tail of list:`cdr`
- Check for empty:`null?`
  Notes:
  - unlike Scheme, ()doesn't work for `null`, but `'()` dose
  - `(list e1 ... en)` for building lists
  - Names `car` and `cdr` are a historical accident