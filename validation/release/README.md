# ActiRune release authority records

## Provider authority lock

`provider_authority.template.json` is deliberately invalid until the product owner has made the production provider and application-identity decisions authoritative.

After those decisions exist, copy the template to:

`validation/release/provider_authority.json`

Fill only these non-secret authority fields:

- `androidApplicationId`
- `iosBundleIdentifier`
- `backendProvider`
- `billingProvider`
- `rewardedAdsProvider`
- `analyticsProvider`

Then run:

```text
dart run tool/validate_provider_authority_lock.dart
```

The validator fails closed when:

- the authority file is missing,
- the schema contains extra/unknown fields,
- any required value is blank,
- provider names are still TBD/placeholder values,
- either app identifier uses `com.example.*`,
- the locked Android id differs from the real Android platform file,
- the locked iOS id differs from the real iOS Runner platform file.

## Secret boundary

Do **not** add API keys, tokens, client secrets, service-account JSON, private keys, signing credentials, ad-unit secrets, RevenueCat keys or Firebase credentials to the authority lock. Unknown fields are rejected partly to make accidental credential stuffing harder.

`PROVIDER_AUTHORITY_LOCK_VALID` proves only that the non-secret provider choice and platform identities are explicit and match the repository platform configuration. It does not prove SDK installation, provider-console configuration, signing, store products, entitlements, ad-unit setup, backend deployment, App Check, analytics delivery or production connectivity.

The Phase-1 aggregate release gate must remain blocked until those separate gates are actually evidenced.
