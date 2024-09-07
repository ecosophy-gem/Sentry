# Sentry Native bindings for Jai

These are basic sentry-native bindings for the Jai programming language.

## Usage

Put this library as `Sentry` in your `modules/` directory. Then:

```
#import "Sentry";

main :: () {
    DEBUG :: true;
    init_sentry("your dsn", "release info", DEBUG);
    sentry_set_level(.WARNING);

    ...
}
```

In order to run, the `crashpad_handler` executable must be in the same location
as your binary, and `libsentry.so` must be found. Both can be obtained by running `build.sh`.

For way more information, see [the sentry-native documentation](https://docs.sentry.io/platforms/native/)
