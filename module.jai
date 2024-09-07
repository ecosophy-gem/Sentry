#if OS == .LINUX {
    #import "POSIX";
    va_list :: *void;

    #load "linux.jai";
}


init_sentry :: (dsn: string, release: string, debug: bool) {
    options := sentry_options_new();
    sentry_options_set_dsn(options, to_c_string(dsn));
    sentry_options_set_release(options, to_c_string(release));
    sentry_options_set_debug(options, xx debug);
    sentry_init(options);
}
