//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



SENTRY_SDK_NAME :: "sentry.native";

SENTRY_SDK_VERSION :: "0.7.9";

sentry_string_free :: sentry_free;

/**
* Allocates memory with the underlying allocator.
*/
sentry_malloc :: (size: u64) -> *void #foreign libsentry;

/**
* Releases memory allocated from the underlying allocator.
*/
sentry_free :: (ptr: *void) -> void #foreign libsentry;

/**
* Type of a sentry value.
*/
sentry_value_type_t :: enum u32 {
    NULL   :: 0;
    BOOL   :: 1;
    INT32  :: 2;
    DOUBLE :: 3;
    STRING :: 4;
    LIST   :: 5;
    OBJECT :: 6;

    SENTRY_VALUE_TYPE_NULL   :: NULL;
    SENTRY_VALUE_TYPE_BOOL   :: BOOL;
    SENTRY_VALUE_TYPE_INT32  :: INT32;
    SENTRY_VALUE_TYPE_DOUBLE :: DOUBLE;
    SENTRY_VALUE_TYPE_STRING :: STRING;
    SENTRY_VALUE_TYPE_LIST   :: LIST;
    SENTRY_VALUE_TYPE_OBJECT :: OBJECT;
}

/**
* Represents a sentry protocol value.
*
* The members of this type should never be accessed.  They are only here
* so that alignment for the type can be properly determined.
*
* Values must be released with `sentry_value_decref`.  This lowers the
* internal refcount by one.  If the refcount hits zero it's freed.  Some
* values like primitives have no refcount (like null) so operations on
* those are no-ops.
*
* In addition values can be frozen.  Some values like primitives are always
* frozen but lists and dicts are not and can be frozen on demand.  This
* automatically happens for some shared values in the event payload like
* the module list.
*/
sentry_value_u :: union {
    _bits:   u64;
    _double: float64;
}

sentry_value_t :: sentry_value_u;

/**
* Increments the reference count on the value.
*/
sentry_value_incref :: (value: sentry_value_t) -> void #foreign libsentry;

/**
* Decrements the reference count on the value.
*/
sentry_value_decref :: (value: sentry_value_t) -> void #foreign libsentry;

/**
* Returns the refcount of a value.
*/
sentry_value_refcount :: (value: sentry_value_t) -> u64 #foreign libsentry;

/**
* Freezes a value.
*/
sentry_value_freeze :: (value: sentry_value_t) -> void #foreign libsentry;

/**
* Checks if a value is frozen.
*/
sentry_value_is_frozen :: (value: sentry_value_t) -> s32 #foreign libsentry;

/**
* Creates a null value.
*/
sentry_value_new_null :: () -> sentry_value_t #foreign libsentry;

/**
* Creates a new 32-bit signed integer value.
*/
sentry_value_new_int32 :: (value: s32) -> sentry_value_t #foreign libsentry;

/**
* Creates a new double value.
*/
sentry_value_new_double :: (value: float64) -> sentry_value_t #foreign libsentry;

/**
* Creates a new boolean value.
*/
sentry_value_new_bool :: (value: s32) -> sentry_value_t #foreign libsentry;

/**
* Creates a new null terminated string.
*/
sentry_value_new_string :: (value: *u8) -> sentry_value_t #foreign libsentry;
sentry_value_new_string_n :: (value: *u8, value_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Creates a new list value.
*/
sentry_value_new_list :: () -> sentry_value_t #foreign libsentry;

/**
* Creates a new object.
*/
sentry_value_new_object :: () -> sentry_value_t #foreign libsentry;

/**
* Returns the type of the value passed.
*/
sentry_value_get_type :: (value: sentry_value_t) -> sentry_value_type_t #foreign libsentry;

/**
* Sets a key to a value in the map.
*
* This moves the ownership of the value into the map.  The caller does not
* have to call `sentry_value_decref` on it.
*/
sentry_value_set_by_key :: (value: sentry_value_t, k: *u8, v: sentry_value_t) -> s32 #foreign libsentry;

sentry_value_set_by_key_n :: (value: sentry_value_t, k: *u8, k_len: u64, v: sentry_value_t) -> s32 #foreign libsentry;

/**
* This removes a value from the map by key.
*/
sentry_value_remove_by_key :: (value: sentry_value_t, k: *u8) -> s32 #foreign libsentry;
sentry_value_remove_by_key_n :: (value: sentry_value_t, k: *u8, k_len: u64) -> s32 #foreign libsentry;

/**
* Appends a value to a list.
*
* This moves the ownership of the value into the list.  The caller does not
* have to call `sentry_value_decref` on it.
*/
sentry_value_append :: (value: sentry_value_t, v: sentry_value_t) -> s32 #foreign libsentry;

/**
* Inserts a value into the list at a certain position.
*
* This moves the ownership of the value into the list.  The caller does not
* have to call `sentry_value_decref` on it.
*
* If the list is shorter than the given index it's automatically extended
* and filled with `null` values.
*/
sentry_value_set_by_index :: (value: sentry_value_t, index: u64, v: sentry_value_t) -> s32 #foreign libsentry;

/**
* This removes a value from the list by index.
*/
sentry_value_remove_by_index :: (value: sentry_value_t, index: u64) -> s32 #foreign libsentry;

/**
* Looks up a value in a map by key.  If missing a null value is returned.
* The returned value is borrowed.
*/
sentry_value_get_by_key :: (value: sentry_value_t, k: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_get_by_key_n :: (value: sentry_value_t, k: *u8, k_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Looks up a value in a map by key.  If missing a null value is returned.
* The returned value is owned.
*
* If the caller no longer needs the value it must be released with
* `sentry_value_decref`.
*/
sentry_value_get_by_key_owned :: (value: sentry_value_t, k: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_get_by_key_owned_n :: (value: sentry_value_t, k: *u8, k_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Looks up a value in a list by index.  If missing a null value is returned.
* The returned value is borrowed.
*/
sentry_value_get_by_index :: (value: sentry_value_t, index: u64) -> sentry_value_t #foreign libsentry;

/**
* Looks up a value in a list by index.  If missing a null value is
* returned. The returned value is owned.
*
* If the caller no longer needs the value it must be released with
* `sentry_value_decref`.
*/
sentry_value_get_by_index_owned :: (value: sentry_value_t, index: u64) -> sentry_value_t #foreign libsentry;

/**
* Returns the length of the given map or list.
*
* If an item is not a list or map the return value is 0.
*/
sentry_value_get_length :: (value: sentry_value_t) -> u64 #foreign libsentry;

/**
* Converts a value into a 32bit signed integer.
*/
sentry_value_as_int32 :: (value: sentry_value_t) -> s32 #foreign libsentry;

/**
* Converts a value into a double value.
*/
sentry_value_as_double :: (value: sentry_value_t) -> float64 #foreign libsentry;

/**
* Returns the value as c string.
*/
sentry_value_as_string :: (value: sentry_value_t) -> *u8 #foreign libsentry;

/**
* Returns `true` if the value is boolean true.
*/
sentry_value_is_true :: (value: sentry_value_t) -> s32 #foreign libsentry;

/**
* Returns `true` if the value is null.
*/
sentry_value_is_null :: (value: sentry_value_t) -> s32 #foreign libsentry;

/**
* Serialize a sentry value to JSON.
*
* The string is freshly allocated and must be freed with
* `sentry_string_free`.
*/
sentry_value_to_json :: (value: sentry_value_t) -> *u8 #foreign libsentry;

/**
* Sentry levels for events and breadcrumbs.
*/
sentry_level_e :: enum s32 {
    DEBUG   :: -1;
    INFO    :: 0;
    WARNING :: 1;
    ERROR   :: 2;
    FATAL   :: 3;

    SENTRY_LEVEL_DEBUG   :: DEBUG;
    SENTRY_LEVEL_INFO    :: INFO;
    SENTRY_LEVEL_WARNING :: WARNING;
    SENTRY_LEVEL_ERROR   :: ERROR;
    SENTRY_LEVEL_FATAL   :: FATAL;
}

/**
* Sentry levels for events and breadcrumbs.
*/
sentry_level_t :: sentry_level_e;

/**
* Creates a new empty Event value.
*
* See https://docs.sentry.io/platforms/native/enriching-events/ for how to
* further work with events, and https://develop.sentry.dev/sdk/event-payloads/
* for a detailed overview of the possible properties of an Event.
*/
sentry_value_new_event :: () -> sentry_value_t #foreign libsentry;

/**
* Creates a new Message Event value.
*
* See https://develop.sentry.dev/sdk/event-payloads/message/
*
* `logger` can be NULL to omit the logger value.
*/
sentry_value_new_message_event :: (level: sentry_level_t, logger: *u8, text: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_new_message_event_n :: (level: sentry_level_t, logger: *u8, logger_len: u64, text: *u8, text_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Creates a new Breadcrumb with a specific type and message.
*
* See https://develop.sentry.dev/sdk/event-payloads/breadcrumbs/
*
* Either parameter can be NULL in which case no such attributes is created.
*/
sentry_value_new_breadcrumb :: (type: *u8, message: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_new_breadcrumb_n :: (type: *u8, type_len: u64, message: *u8, message_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Creates a new Exception value.
*
* This is intended for capturing language-level exception, such as from a
* try-catch block. `type` and `value` here refer to the exception class and
* a possible description.
*
* See https://develop.sentry.dev/sdk/event-payloads/exception/
*
* The returned value needs to be attached to an event via
* `sentry_event_add_exception`.
*/
sentry_value_new_exception :: (type: *u8, value: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_new_exception_n :: (type: *u8, type_len: u64, value: *u8, value_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Creates a new Thread value.
*
* See https://develop.sentry.dev/sdk/event-payloads/threads/
*
* The returned value needs to be attached to an event via
* `sentry_event_add_thread`.
*
* `name` can be NULL.
*/
sentry_value_new_thread :: (id: u64, name: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_new_thread_n :: (id: u64, name: *u8, name_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Creates a new Stack Trace conforming to the Stack Trace Interface.
*
* See https://develop.sentry.dev/sdk/event-payloads/stacktrace/
*
* The returned object must be attached to either an exception or thread
* object.
*
* If `ips` is NULL the current stack trace is captured, otherwise `len`
* stack trace instruction pointers are attached to the event.
*/
sentry_value_new_stacktrace :: (ips: **void, len: u64) -> sentry_value_t #foreign libsentry;

/**
* Sets the Stack Trace conforming to the Stack Trace Interface in a value.
*
* The value argument must be either an exception or thread object.
*
* If `ips` is NULL the current stack trace is captured, otherwise `len` stack
* trace instruction pointers are attached to the event.
*/
sentry_value_set_stacktrace :: (value: sentry_value_t, ips: **void, len: u64) -> void #foreign libsentry;

/**
* Adds an Exception to an Event value.
*
* This takes ownership of the `exception`.
*/
sentry_event_add_exception :: (event: sentry_value_t, exception: sentry_value_t) -> void #foreign libsentry;

/**
* Adds a Thread to an Event value.
*
* This takes ownership of the `thread`.
*/
sentry_event_add_thread :: (event: sentry_value_t, thread: sentry_value_t) -> void #foreign libsentry;

/**
* Serialize a sentry value to msgpack.
*
* The string is freshly allocated and must be freed with
* `sentry_string_free`.  Since msgpack is not zero terminated
* the size is written to the `size_out` parameter.
*/
sentry_value_to_msgpack :: (value: sentry_value_t, size_out: *u64) -> *u8 #foreign libsentry;

/**
* Adds a stack trace to an event.
*
* The stack trace is added as part of a new thread object.
* This function is **deprecated** in favor of using
* `sentry_value_new_stacktrace` in combination with `sentry_value_new_thread`
* and `sentry_event_add_thread`.
*
* If `ips` is NULL the current stack trace is captured, otherwise `len`
* stack trace instruction pointers are attached to the event.
*/
sentry_event_value_add_stacktrace :: (event: sentry_value_t, ips: **void, len: u64) -> void #foreign libsentry;

/**
* This represents the OS dependent user context in the case of a crash, and can
* be used to manually capture a crash.
*/
sentry_ucontext_s :: struct {
    signum:       s32;
    siginfo:      *siginfo_t;
    user_context: *ucontext_t;
}

/**
* This represents the OS dependent user context in the case of a crash, and can
* be used to manually capture a crash.
*/
sentry_ucontext_t :: sentry_ucontext_s;

/**
* Unwinds the stack from the given address.
*
* If the address is given in `addr` the stack is unwound form there.
* Otherwise (NULL is passed) the current instruction pointer is used as
* start address.
* Unwinding with a given `addr` is not supported on all platforms.
*
* The stack trace in the form of instruction-addresses, is written to the
* caller allocated `stacktrace_out`, with up to `max_len` frames being written.
* The actual number of unwound stackframes is returned.
*/
sentry_unwind_stack :: (addr: *void, stacktrace_out: **void, max_len: u64) -> u64 #foreign libsentry;

/**
* Unwinds the stack from the given context.
*
* The caller is responsible to construct an appropriate `sentry_ucontext_t`.
* Unwinding from a user context is not supported on all platforms.
*
* The stack trace in the form of instruction-addresses, is written to the
* caller allocated `stacktrace_out`, with up to `max_len` frames being written.
* The actual number of unwound stackframes is returned.
*/
sentry_unwind_stack_from_ucontext :: (uctx: *sentry_ucontext_t, stacktrace_out: **void, max_len: u64) -> u64 #foreign libsentry;

/**
* A UUID
*/
sentry_uuid_s :: struct {
    bytes: [16] u8;
}

/**
* A UUID
*/
sentry_uuid_t :: sentry_uuid_s;

/**
* Creates the nil uuid.
*/
sentry_uuid_nil :: () -> sentry_uuid_t #foreign libsentry;

/**
* Creates a new uuid4.
*/
sentry_uuid_new_v4 :: () -> sentry_uuid_t #foreign libsentry;

/**
* Parses a uuid from a string.
*/
sentry_uuid_from_string :: (str: *u8) -> sentry_uuid_t #foreign libsentry;
sentry_uuid_from_string_n :: (str: *u8, str_len: u64) -> sentry_uuid_t #foreign libsentry;

/**
* Creates a uuid from bytes.
*/
sentry_uuid_from_bytes :: (bytes: *[16] u8) -> sentry_uuid_t #foreign libsentry;

/**
* Checks if the uuid is nil.
*/
sentry_uuid_is_nil :: (uuid: *sentry_uuid_t) -> s32 #foreign libsentry;

/**
* Returns the bytes of the uuid.
*/
sentry_uuid_as_bytes :: (uuid: *sentry_uuid_t, bytes: *[16] u8) -> void #foreign libsentry;

/**
* Formats the uuid into a string buffer.
*/
sentry_uuid_as_string :: (uuid: *sentry_uuid_t, str: *[37] u8) -> void #foreign libsentry;

/**
* A Sentry Envelope.
*
* The Envelope is an abstract type which represents a payload being sent to
* sentry. It can contain one or more items, typically an Event.
* See https://develop.sentry.dev/sdk/envelopes/
*/
sentry_envelope_s :: struct {}
sentry_envelope_t :: sentry_envelope_s;

/**
* Frees an envelope.
*/
sentry_envelope_free :: (envelope: *sentry_envelope_t) -> void #foreign libsentry;

/**
* Given an Envelope, returns the embedded Event if there is one.
*
* This returns a borrowed value to the Event in the Envelope.
*/
sentry_envelope_get_event :: (envelope: *sentry_envelope_t) -> sentry_value_t #foreign libsentry;

/**
* Given an Envelope, returns the embedded Transaction if there is one.
*
* This returns a borrowed value to the Transaction in the Envelope.
*/
sentry_envelope_get_transaction :: (envelope: *sentry_envelope_t) -> sentry_value_t #foreign libsentry;

/**
* Serializes the envelope.
*
* The return value needs to be freed with sentry_string_free().
*/
sentry_envelope_serialize :: (envelope: *sentry_envelope_t, size_out: *u64) -> *u8 #foreign libsentry;

/**
* Serializes the envelope into a file.
*
* `path` is assumed to be in platform-specific filesystem path encoding.
*
* Returns 0 on success.
*/
sentry_envelope_write_to_file :: (envelope: *sentry_envelope_t, path: *u8) -> s32 #foreign libsentry;

sentry_envelope_write_to_file_n :: (envelope: *sentry_envelope_t, path: *u8, path_len: u64) -> s32 #foreign libsentry;

/**
* The Sentry Client Options.
*
* See https://docs.sentry.io/platforms/native/configuration/
*/
sentry_options_s :: struct {}
sentry_options_t :: sentry_options_s;

/**
* This represents an interface for user-defined transports.
*
* Transports are responsible for sending envelopes to sentry and are the last
* step in the event pipeline.
*
* Envelopes will be submitted to the transport in a _fire and forget_ fashion,
* and the transport must send those envelopes _in order_.
*
* A transport has the following hooks, all of which
* take the user provided `state` as last parameter. The transport state needs
* to be set with `sentry_transport_set_state` and typically holds handles and
* other information that can be reused across requests.
*
* * `send_func`: This function will take ownership of an envelope, and is
*   responsible for freeing it via `sentry_envelope_free`.
* * `startup_func`: This hook will be called by sentry inside of `sentry_init`
*   and instructs the transport to initialize itself. Failures will bubble up
*   to `sentry_init`.
* * `flush_func`: Instructs the transport to flush its queue.
*   This hook receives a millisecond-resolution `timeout` parameter and should
*   return `0` if the transport queue is flushed within the timeout.
* * `shutdown_func`: Instructs the transport to flush its queue and shut down.
*   This hook receives a millisecond-resolution `timeout` parameter and should
*   return `0` if the transport is flushed and shut down successfully.
*   In case of a non-zero return value, sentry will log an error, but continue
* with freeing the transport.
* * `free_func`: Frees the transports `state`. This hook might be called even
*   though `shutdown_func` returned a failure code previously.
*
* The transport interface might be extended in the future with hooks to flush
* its internal queue without shutting down, and to dump its internal queue to
* disk in case of a hard crash.
*/
sentry_transport_s :: struct {}
sentry_transport_t :: sentry_transport_s;

/**
* Creates a new transport with an initial `send_func`.
*/
sentry_transport_new :: (send_func: #type (envelope: *sentry_envelope_t, state: *void) -> void #c_call) -> *sentry_transport_t #foreign libsentry;

/**
* Sets the transport `state`.
*
* If the state is owned by the transport and needs to be freed, use
* `sentry_transport_set_free_func` to set an appropriate hook.
*/
sentry_transport_set_state :: (transport: *sentry_transport_t, state: *void) -> void #foreign libsentry;

/**
* Sets the transport hook to free the transport `state`.
*/
sentry_transport_set_free_func :: (transport: *sentry_transport_t, free_func: #type (state: *void) -> void #c_call) -> void #foreign libsentry;

/**
* Sets the transport startup hook.
*
* This hook is called from within `sentry_init` and will get a reference to the
* options which can be used to initialize a transports internal state.
* It should return `0` on success. A failure will bubble up to `sentry_init`.
*/
sentry_transport_set_startup_func :: (transport: *sentry_transport_t, startup_func: #type (options: *sentry_options_t, state: *void) -> s32 #c_call) -> void #foreign libsentry;

/**
* Sets the transport flush hook.
*
* This hook will receive a millisecond-resolution timeout.
* It should return `0` if all the pending envelopes are
* sent within the timeout, or `1` if the timeout is hit.
*/
sentry_transport_set_flush_func :: (transport: *sentry_transport_t, flush_func: #type (timeout: u64, state: *void) -> s32 #c_call) -> void #foreign libsentry;

/**
* Sets the transport shutdown hook.
*
* This hook will receive a millisecond-resolution timeout.
* It should return `0` on success in case all the pending envelopes have been
* sent within the timeout, or `1` if the timeout was hit.
*/
sentry_transport_set_shutdown_func :: (transport: *sentry_transport_t, shutdown_func: #type (timeout: u64, state: *void) -> s32 #c_call) -> void #foreign libsentry;

/**
* Generic way to free a transport.
*/
sentry_transport_free :: (transport: *sentry_transport_t) -> void #foreign libsentry;

/**
* Create a new function transport.
*
* It is a convenience function which works with a borrowed `data`, and will
* automatically free the envelope, so the user provided function does not need
* to do that.
*
* This function is *deprecated* and will be removed in a future version.
* It is here for backwards compatibility. Users should migrate to the
* `sentry_transport_new` API.
*/
sentry_new_function_transport :: (func: #type (envelope: *sentry_envelope_t, data: *void) -> void #c_call, data: *void) -> *sentry_transport_t #foreign libsentry;

/**
* This represents an interface for user-defined backends.
*
* Backends are responsible to handle crashes. They are maintained at runtime
* via various life-cycle hooks from the sentry-core.
*
* At this point none of those interfaces are exposed in the API including
* creation and destruction. The main use-case of the backend in the API at this
* point is to disable it via `sentry_options_set_backend` at runtime before it
* is initialized.
*/
sentry_backend_s :: struct {}
sentry_backend_t :: sentry_backend_s;

/**
* The state of user consent.
*/
sentry_user_consent_t :: enum s32 {
    UNKNOWN :: -1;
    GIVEN   :: 1;
    REVOKED :: 0;

    SENTRY_USER_CONSENT_UNKNOWN :: UNKNOWN;
    SENTRY_USER_CONSENT_GIVEN   :: GIVEN;
    SENTRY_USER_CONSENT_REVOKED :: REVOKED;
}

/**
* Creates a new options struct.
* Can be freed with `sentry_options_free`.
*/
sentry_options_new :: () -> *sentry_options_t #foreign libsentry;

/**
* Deallocates previously allocated sentry options.
*/
sentry_options_free :: (opts: *sentry_options_t) -> void #foreign libsentry;

/**
* Sets a transport.
*/
sentry_options_set_transport :: (opts: *sentry_options_t, transport: *sentry_transport_t) -> void #foreign libsentry;

/**
* Type of the `before_send` callback.
*
* The callback takes ownership of the `event`, and should usually return that
* same event. In case the event should be discarded, the callback needs to
* call `sentry_value_decref` on the provided event, and return a
* `sentry_value_new_null()` instead.
*
* If you have set an `on_crash` callback (independent of whether it discards or
* retains the event), `before_send` will no longer be invoked for crash-events,
* which allows you to better distinguish between crashes and all other events
* in client-side pre-processing.
*
* This function may be invoked inside of a signal handler and must be safe for
* that purpose, see https://man7.org/linux/man-pages/man7/signal-safety.7.html.
* On Windows, it may be called from inside of a `UnhandledExceptionFilter`, see
* the documentation on SEH (structured exception handling) for more information
* https://docs.microsoft.com/en-us/windows/win32/debug/structured-exception-handling
*
* Up to version 0.4.18 the `before_send` callback wasn't invoked in case the
* event sampling discarded an event. In the current implementation the
* `before_send` callback is invoked even if the event sampling discards the
* event, following the cross-SDK session filter order:
*
* https://develop.sentry.dev/sdk/sessions/#filter-order
*
* On Windows the crashpad backend can capture fast-fail crashes which by-pass
* SEH. Since the `before_send` is called by a local exception-handler, it will
* not be invoked when such a crash happened, even though a minidump will be
* sent.
*/
sentry_event_function_t :: #type (event: sentry_value_t, hint: *void, closure: *void) -> sentry_value_t #c_call;

/**
* Sets the `before_send` callback.
*
* See the `sentry_event_function_t` typedef above for more information.
*/
sentry_options_set_before_send :: (opts: *sentry_options_t, func: sentry_event_function_t, data: *void) -> void #foreign libsentry;

/**
* Type of the `on_crash` callback.
*
* The `on_crash` callback replaces the `before_send` callback for crash events.
* The interface is analogous to `before_send` in that the callback takes
* ownership of the `event`, and should usually return that same event. In case
* the event should be discarded, the callback needs to call
* `sentry_value_decref` on the provided event, and return a
* `sentry_value_new_null()` instead.
*
* Only the `inproc` backend currently fills the passed-in event with useful
* data and processes any modifications to the return value. Since both
* `breakpad` and `crashpad` use minidumps to capture the crash state, the
* passed-in event is empty when using these backends, and they ignore any
* changes to the return value.
*
* If you set this callback in the options, it prevents a concurrently enabled
* `before_send` callback from being invoked in the crash case. This allows for
* better differentiation between crashes and other events and gradual migration
* from existing `before_send` implementations:
*
*  - if you have a `before_send` implementation and do not define an `on_crash`
*    callback your application will receive both normal and crash events as
*    before
*  - if you have a `before_send` implementation but only want to handle normal
*    events with it, then you can define an `on_crash` callback that returns
*    the passed-in event and does nothing else
*  - if you are not interested in normal events, but only want to act on
*    crashes (within the limits mentioned below), then only define an
*    `on_crash` callback with the option to filter (on all backends) or enrich
*    (only inproc) the crash event
*
* This function may be invoked inside of a signal handler and must be safe for
* that purpose, see https://man7.org/linux/man-pages/man7/signal-safety.7.html.
* On Windows, it may be called from inside of a `UnhandledExceptionFilter`, see
* the documentation on SEH (structured exception handling) for more information
* https://docs.microsoft.com/en-us/windows/win32/debug/structured-exception-handling
*
* Platform-specific behavior:
*
*  - does not work with crashpad on macOS.
*  - for breakpad on Linux the `uctx` parameter is always NULL.
*  - on Windows the crashpad backend can capture fast-fail crashes which
* by-pass SEH. Since `on_crash` is called by a local exception-handler, it will
* not be invoked when such a crash happened, even though a minidump will be
* sent.
*/
sentry_crash_function_t :: #type (uctx: *sentry_ucontext_t, event: sentry_value_t, closure: *void) -> sentry_value_t #c_call;

/**
* Sets the `on_crash` callback.
*
* See the `sentry_crash_function_t` typedef above for more information.
*/
sentry_options_set_on_crash :: (opts: *sentry_options_t, func: sentry_crash_function_t, data: *void) -> void #foreign libsentry;

/**
* Sets the DSN.
*/
sentry_options_set_dsn :: (opts: *sentry_options_t, dsn: *u8) -> void #foreign libsentry;
sentry_options_set_dsn_n :: (opts: *sentry_options_t, dsn: *u8, dsn_len: u64) -> void #foreign libsentry;

/**
* Gets the DSN.
*/
sentry_options_get_dsn :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Sets the sample rate, which should be a double between `0.0` and `1.0`.
* Sentry will randomly discard any event that is captured using
* `sentry_capture_event` when a sample rate < 1 is set.
*
* The sampling happens at the end of the event processing according to the
* following order:
*
* https://develop.sentry.dev/sdk/sessions/#filter-order
*
* Only items 3. to 6. are currently applicable to sentry-native. This means
* each processing step is executed even if the sampling discards the event
* before sending it to the backend. This is particularly relevant to users of
* the `before_send` callback.
*
* The above is in contrast to versions up to 0.4.18 where the sampling happened
* at the beginning of the processing/filter sequence.
*/
sentry_options_set_sample_rate :: (opts: *sentry_options_t, sample_rate: float64) -> void #foreign libsentry;

/**
* Gets the sample rate.
*/
sentry_options_get_sample_rate :: (opts: *sentry_options_t) -> float64 #foreign libsentry;

/**
* Sets the release.
*/
sentry_options_set_release :: (opts: *sentry_options_t, release: *u8) -> void #foreign libsentry;

sentry_options_set_release_n :: (opts: *sentry_options_t, release: *u8, release_len: u64) -> void #foreign libsentry;

/**
* Gets the release.
*/
sentry_options_get_release :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Sets the environment.
*/
sentry_options_set_environment :: (opts: *sentry_options_t, environment: *u8) -> void #foreign libsentry;

sentry_options_set_environment_n :: (opts: *sentry_options_t, environment: *u8, environment_len: u64) -> void #foreign libsentry;

/**
* Gets the environment.
*/
sentry_options_get_environment :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Sets the dist.
*/
sentry_options_set_dist :: (opts: *sentry_options_t, dist: *u8) -> void #foreign libsentry;

sentry_options_set_dist_n :: (opts: *sentry_options_t, dist: *u8, dist_len: u64) -> void #foreign libsentry;

/**
* Gets the dist.
*/
sentry_options_get_dist :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Configures the http proxy.
*
* The given proxy has to include the full scheme, eg. `http://some.proxy/`.
*/
sentry_options_set_http_proxy :: (opts: *sentry_options_t, proxy: *u8) -> void #foreign libsentry;

sentry_options_set_http_proxy_n :: (opts: *sentry_options_t, proxy: *u8, proxy_len: u64) -> void #foreign libsentry;

/**
* Returns the configured http proxy.
*/
sentry_options_get_http_proxy :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Configures the path to a file containing ssl certificates for
* verification.
*/
sentry_options_set_ca_certs :: (opts: *sentry_options_t, path: *u8) -> void #foreign libsentry;

sentry_options_set_ca_certs_n :: (opts: *sentry_options_t, path: *u8, path_len: u64) -> void #foreign libsentry;

/**
* Returns the configured path for ca certificates.
*/
sentry_options_get_ca_certs :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Configures the name of the http transport thread.
*/
sentry_options_set_transport_thread_name :: (opts: *sentry_options_t, name: *u8) -> void #foreign libsentry;

sentry_options_set_transport_thread_name_n :: (opts: *sentry_options_t, name: *u8, name_len: u64) -> void #foreign libsentry;

/**
* Returns the configured http transport thread name.
*/
sentry_options_get_transport_thread_name :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/*
* Configures the name of the sentry SDK. Returns 0 on success.
*/
sentry_options_set_sdk_name :: (opts: *sentry_options_t, sdk_name: *u8) -> s32 #foreign libsentry;

/*
* Configures the name of the sentry SDK. Returns 0 on success.
*/
sentry_options_set_sdk_name_n :: (opts: *sentry_options_t, sdk_name: *u8, sdk_name_len: u64) -> s32 #foreign libsentry;

/**
* Returns the configured sentry SDK name. Unless overwritten this defaults to
* SENTRY_SDK_NAME.
*/
sentry_options_get_sdk_name :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Returns the user agent. Unless overwritten this defaults to
* "SENTRY_SDK_NAME / SENTRY_SDK_VERSION".
*/
sentry_options_get_user_agent :: (opts: *sentry_options_t) -> *u8 #foreign libsentry;

/**
* Enables or disables debug printing mode.
*/
sentry_options_set_debug :: (opts: *sentry_options_t, debug: s32) -> void #foreign libsentry;

/**
* Returns the current value of the debug flag.
*/
sentry_options_get_debug :: (opts: *sentry_options_t) -> s32 #foreign libsentry;

/**
* Sets the number of breadcrumbs being tracked and attached to events.
*
* Defaults to 100.
*/
sentry_options_set_max_breadcrumbs :: (opts: *sentry_options_t, max_breadcrumbs: u64) -> void #foreign libsentry;

/**
* Gets the number of breadcrumbs being tracked and attached to events.
*/
sentry_options_get_max_breadcrumbs :: (opts: *sentry_options_t) -> u64 #foreign libsentry;

/**
* Type of the callback for logger function.
*/
sentry_logger_function_t :: #type (level: sentry_level_t, message: *u8, args: va_list, userdata: *void) -> void #c_call;

/**
* Sets the sentry-native logger function.
*
* Used for logging debug events when the `debug` option is set to true.
*
* Note: Multiple threads may invoke your `func`. If you plan to mutate any data
* inside the `userdata` argument after initialization, you must ensure proper
* synchronization inside the logger function.
*
*/
sentry_options_set_logger :: (opts: *sentry_options_t, func: sentry_logger_function_t, userdata: *void) -> void #foreign libsentry;

/**
* Enables or disables automatic session tracking.
*
* Automatic session tracking is enabled by default and is equivalent to calling
* `sentry_start_session` after startup.
* There can only be one running session, and the current session will always be
* closed implicitly by `sentry_close`, when starting a new session with
* `sentry_start_session`, or manually by calling `sentry_end_session`.
*/
sentry_options_set_auto_session_tracking :: (opts: *sentry_options_t, val: s32) -> void #foreign libsentry;

/**
* Returns true if automatic session tracking is enabled.
*/
sentry_options_get_auto_session_tracking :: (opts: *sentry_options_t) -> s32 #foreign libsentry;

/**
* Enables or disables user consent requirements for uploads.
*
* This disables uploads until the user has given the consent to the SDK.
* Consent itself is given with `sentry_user_consent_give` and
* `sentry_user_consent_revoke`.
*/
sentry_options_set_require_user_consent :: (opts: *sentry_options_t, val: s32) -> void #foreign libsentry;

/**
* Returns true if user consent is required.
*/
sentry_options_get_require_user_consent :: (opts: *sentry_options_t) -> s32 #foreign libsentry;

/**
* Enables or disables on-device symbolication of stack traces.
*
* This feature can have a performance impact, and is enabled by default on
* Android. It is usually only needed when it is not possible to provide debug
* information files for system libraries which are needed for serverside
* symbolication.
*/
sentry_options_set_symbolize_stacktraces :: (opts: *sentry_options_t, val: s32) -> void #foreign libsentry;

/**
* Returns true if on-device symbolication of stack traces is enabled.
*/
sentry_options_get_symbolize_stacktraces :: (opts: *sentry_options_t) -> s32 #foreign libsentry;

/**
* Adds a new attachment to be sent along.
*
* `path` is assumed to be in platform-specific filesystem path encoding.
* API Users on windows are encouraged to use `sentry_options_add_attachmentw`
* instead.
*/
sentry_options_add_attachment :: (opts: *sentry_options_t, path: *u8) -> void #foreign libsentry;

sentry_options_add_attachment_n :: (opts: *sentry_options_t, path: *u8, path_len: u64) -> void #foreign libsentry;

/**
* Sets the path to the crashpad handler if the crashpad backend is used.
*
* The path defaults to the `crashpad_handler`/`crashpad_handler.exe`
* executable, depending on platform, which is expected to be present in the
* same directory as the app executable.
*
* It is recommended that library users set an explicit handler path, depending
* on the directory/executable structure of their app.
*
* `path` is assumed to be in platform-specific filesystem path encoding.
* API Users on windows are encouraged to use `sentry_options_set_handler_pathw`
* instead.
*/
sentry_options_set_handler_path :: (opts: *sentry_options_t, path: *u8) -> void #foreign libsentry;

sentry_options_set_handler_path_n :: (opts: *sentry_options_t, path: *u8, path_len: u64) -> void #foreign libsentry;

/**
* Sets the path to the Sentry Database Directory.
*
* Sentry will use this path to persist user consent, sessions, and other
* artifacts in case of a crash. This will also be used by the crashpad backend
* if it is configured.
*
* The directory is used for "cached" data, which needs to persist across
* application restarts to ensure proper flagging of release-health sessions,
* but might otherwise be safely purged regularly.
*
* It is roughly equivalent to the type of `AppData/Local` on Windows and
* `XDG_CACHE_HOME` on Linux, and equivalent runtime directories on other
* platforms.
*
* It is recommended that users set an explicit absolute path, depending
* on their apps runtime directory. The path will be created if it does not
* exist, and will be resolved to an absolute path inside of `sentry_init`. The
* directory should not be shared with other application data/configuration, as
* sentry-native will enumerate and possibly delete files in that directory. An
* example might be `$XDG_CACHE_HOME/your-app/sentry`
*
* If no explicit path it set, sentry-native will default to `.sentry-native` in
* the current working directory, with no specific platform-specific handling.
*
* `path` is assumed to be in platform-specific filesystem path encoding.
* API Users on windows are encouraged to use
* `sentry_options_set_database_pathw` instead.
*/
sentry_options_set_database_path :: (opts: *sentry_options_t, path: *u8) -> void #foreign libsentry;

sentry_options_set_database_path_n :: (opts: *sentry_options_t, path: *u8, path_len: u64) -> void #foreign libsentry;

/**
* Enables forwarding to the system crash reporter. Disabled by default.
*
* This setting only has an effect when using Crashpad on macOS. If enabled,
* Crashpad forwards crashes to the macOS system crash reporter. Depending
* on the crash, this may impact the crash time. Even if enabled, Crashpad
* may choose not to forward certain crashes.
*/
sentry_options_set_system_crash_reporter_enabled :: (opts: *sentry_options_t, enabled: s32) -> void #foreign libsentry;

/**
* Sets the maximum time (in milliseconds) to wait for the asynchronous tasks to
* end on shutdown, before attempting a forced termination.
*/
sentry_options_set_shutdown_timeout :: (opts: *sentry_options_t, shutdown_timeout: u64) -> void #foreign libsentry;

/**
* Gets the maximum time (in milliseconds) to wait for the asynchronous tasks to
* end on shutdown, before attempting a forced termination.
*/
sentry_options_get_shutdown_timeout :: (opts: *sentry_options_t) -> u64 #foreign libsentry;

/**
* Sets a user-defined backend.
*
* Since creation and destruction of backends is not exposed in the API, this
* can only be used to set the backend to `NULL`, which disables the backend in
* the initialization.
*/
sentry_options_set_backend :: (opts: *sentry_options_t, backend: *sentry_backend_t) -> void #foreign libsentry;

/**
* Initializes the Sentry SDK with the specified options.
*
* This takes ownership of the options.  After the options have been set
* they cannot be modified any more.
* Depending on the configured transport and backend, this function might not be
* fully thread-safe.
* Returns 0 on success.
*/
sentry_init :: (options: *sentry_options_t) -> s32 #foreign libsentry;

/**
* Instructs the transport to flush its send queue.
*
* The `timeout` parameter is in milliseconds.
*
* Returns 0 on success, or a non-zero return value in case the timeout is hit.
*
* Note that this function will block the thread it was called from until the
* sentry background worker has finished its work or it timed out, whichever
* comes first.
*/
sentry_flush :: (timeout: u64) -> s32 #foreign libsentry;

/**
* Shuts down the sentry client and forces transports to flush out.
*
* Returns 0 on success.
*
* Note that this does not uninstall any crash handler installed by our
* backends, which will still process crashes after `sentry_close()`, except
* when using `crashpad` on Linux or the `inproc` backend.
*
* Further note that this function will block the thread it was called from
* until the sentry background worker has finished its work or it timed out,
* whichever comes first.
*/
sentry_close :: () -> s32 #foreign libsentry;

/**
* Shuts down the sentry client and forces transports to flush out.
*
* This is a **deprecated** alias for `sentry_close`.
*
* Returns 0 on success.
*/
sentry_shutdown :: () -> s32 #foreign libsentry;

/**
* This will lazily load and cache a list of all the loaded libraries.
*
* Returns a new reference to an immutable, frozen list.
* The reference must be released with `sentry_value_decref`.
*/
sentry_get_modules_list :: () -> sentry_value_t #foreign libsentry;

/**
* Clears the internal module cache.
*
* For performance reasons, sentry will cache the list of loaded libraries when
* capturing events. This cache can get out-of-date when loading or unloading
* libraries at runtime. It is therefore recommended to call
* `sentry_clear_modulecache` when doing so, to make sure that the next call to
* `sentry_capture_event` will have an up-to-date module list.
*/
sentry_clear_modulecache :: () -> void #foreign libsentry;

/**
* Re-initializes the Sentry backend.
*
* This is needed if a third-party library overrides the previously installed
* signal handler. Calling this function can be potentially dangerous and should
* only be done when necessary.
*
* Returns 0 on success.
*/
sentry_reinstall_backend :: () -> s32 #foreign libsentry;

/**
* Gives user consent.
*/
sentry_user_consent_give :: () -> void #foreign libsentry;

/**
* Revokes user consent.
*/
sentry_user_consent_revoke :: () -> void #foreign libsentry;

/**
* Resets the user consent (back to unknown).
*/
sentry_user_consent_reset :: () -> void #foreign libsentry;

/**
* Checks the current state of user consent.
*/
sentry_user_consent_get :: () -> sentry_user_consent_t #foreign libsentry;

/**
* Sends a sentry event.
*
* If returns a nil UUID if the event being passed in is a transaction, and the
* transaction will not be sent nor consumed. `sentry_transaction_finish` should
* be used to send transactions.
*/
sentry_capture_event :: (event: sentry_value_t) -> sentry_uuid_t #foreign libsentry;

/**
* Captures an exception to be handled by the backend.
*
* This is safe to be called from a crashing thread and may not return.
*
* Note: The `crashpad` client currently supports this only on Windows. `inproc`
*       and `breakpad` support it on all platforms.
*/
sentry_handle_exception :: (uctx: *sentry_ucontext_t) -> void #foreign libsentry;

/**
* Adds the breadcrumb to be sent in case of an event.
*/
sentry_add_breadcrumb :: (breadcrumb: sentry_value_t) -> void #foreign libsentry;

/**
* Sets the specified user.
*/
sentry_set_user :: (user: sentry_value_t) -> void #foreign libsentry;

/**
* Removes a user.
*/
sentry_remove_user :: () -> void #foreign libsentry;

/**
* Sets a tag.
*/
sentry_set_tag :: (key: *u8, value: *u8) -> void #foreign libsentry;
sentry_set_tag_n :: (key: *u8, key_len: u64, value: *u8, value_len: u64) -> void #foreign libsentry;

/**
* Removes the tag with the specified key.
*/
sentry_remove_tag :: (key: *u8) -> void #foreign libsentry;
sentry_remove_tag_n :: (key: *u8, key_len: u64) -> void #foreign libsentry;

/**
* Sets extra information.
*/
sentry_set_extra :: (key: *u8, value: sentry_value_t) -> void #foreign libsentry;
sentry_set_extra_n :: (key: *u8, key_len: u64, value: sentry_value_t) -> void #foreign libsentry;

/**
* Removes the extra with the specified key.
*/
sentry_remove_extra :: (key: *u8) -> void #foreign libsentry;
sentry_remove_extra_n :: (key: *u8, key_len: u64) -> void #foreign libsentry;

/**
* Sets a context object.
*/
sentry_set_context :: (key: *u8, value: sentry_value_t) -> void #foreign libsentry;
sentry_set_context_n :: (key: *u8, key_len: u64, value: sentry_value_t) -> void #foreign libsentry;

/**
* Removes the context object with the specified key.
*/
sentry_remove_context :: (key: *u8) -> void #foreign libsentry;
sentry_remove_context_n :: (key: *u8, key_len: u64) -> void #foreign libsentry;

/**
* Sets the event fingerprint.
*
* This accepts a variable number of arguments, and needs to be terminated by a
* trailing `NULL`.
*/
sentry_set_fingerprint_CFormat :: (fingerprint: *u8, __args: ..Any) -> void #foreign libsentry "sentry_set_fingerprint";
sentry_set_fingerprint :: (fingerprint: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fingerprint, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    sentry_set_fingerprint_CFormat("%s", formatted_text.data);
} @PrintLike
sentry_set_fingerprint_n :: (fingerprint: *u8, fingerprint_len: u64, __args: ..Any) -> void #foreign libsentry;

/**
* Removes the fingerprint.
*/
sentry_remove_fingerprint :: () -> void #foreign libsentry;

/**
* Sets the transaction.
*/
sentry_set_transaction :: (transaction: *u8) -> void #foreign libsentry;
sentry_set_transaction_n :: (transaction: *u8, transaction_len: u64) -> void #foreign libsentry;

/**
* Sets the event level.
*/
sentry_set_level :: (level: sentry_level_t) -> void #foreign libsentry;

/**
* Sets the maximum number of spans that can be attached to a
* transaction.
*/
sentry_options_set_max_spans :: (opts: *sentry_options_t, max_spans: u64) -> void #foreign libsentry;

/**
* Gets the maximum number of spans that can be attached to a
* transaction.
*/
sentry_options_get_max_spans :: (opts: *sentry_options_t) -> u64 #foreign libsentry;

/**
* Sets the sample rate for transactions. Should be a double between
* `0.0` and `1.0`. Transactions will be randomly discarded during
* `sentry_transaction_finish` when the sample rate is < 1.0.
*/
sentry_options_set_traces_sample_rate :: (opts: *sentry_options_t, sample_rate: float64) -> void #foreign libsentry;

/**
* Returns the sample rate for transactions.
*/
sentry_options_get_traces_sample_rate :: (opts: *sentry_options_t) -> float64 #foreign libsentry;

/* -- Session APIs -- */
sentry_session_status_t :: enum u32 {
    OK       :: 0;
    CRASHED  :: 1;
    ABNORMAL :: 2;
    EXITED   :: 3;

    SENTRY_SESSION_STATUS_OK       :: OK;
    SENTRY_SESSION_STATUS_CRASHED  :: CRASHED;
    SENTRY_SESSION_STATUS_ABNORMAL :: ABNORMAL;
    SENTRY_SESSION_STATUS_EXITED   :: EXITED;
}

/**
* Starts a new session.
*/
sentry_start_session :: () -> void #foreign libsentry;

/**
* Ends a session.
*/
sentry_end_session :: () -> void #foreign libsentry;

/**
* Ends a session with an explicit `status` code.
*/
sentry_end_session_with_status :: (status: sentry_session_status_t) -> void #foreign libsentry;

/**
* A sentry Transaction Context.
*
* See Transaction Interface under
* https://develop.sentry.dev/sdk/performance/#new-span-and-transaction-classes
*/
sentry_transaction_context_s :: struct {}
sentry_transaction_context_t :: sentry_transaction_context_s;

/**
* A sentry Transaction.
*
* See https://develop.sentry.dev/sdk/event-payloads/transaction/
*/
sentry_transaction_s :: struct {}
sentry_transaction_t :: sentry_transaction_s;

/**
* A sentry Span.
*
* See https://develop.sentry.dev/sdk/event-payloads/span/
*/
sentry_span_s :: struct {}
sentry_span_t :: sentry_span_s;

/**
* Constructs a new Transaction Context. The returned value needs to be passed
* into `sentry_transaction_start` in order to be recorded and sent to sentry.
*
* See
* https://docs.sentry.io/platforms/native/enriching-events/transaction-name/
* for an explanation of a Transaction's `name`, and
* https://develop.sentry.dev/sdk/performance/span-operations/ for conventions
* around an `operation`'s value.
*
* Also see https://develop.sentry.dev/sdk/event-payloads/transaction/#anatomy
* for an explanation of `operation`, in addition to other properties and
* actions that can be performed on a Transaction.
*
* The returned value is not thread-safe. Users are expected to ensure that
* appropriate locking mechanisms are implemented over the Transaction Context
* if it needs to be mutated across threads. Methods operating on the
* Transaction Context will mention what kind of expectations they carry if they
* need to mutate or access the object in a thread-safe way.
*/
sentry_transaction_context_new :: (name: *u8, operation: *u8) -> *sentry_transaction_context_t #foreign libsentry;

sentry_transaction_context_new_n :: (name: *u8, name_len: u64, operation: *u8, operation_len: u64) -> *sentry_transaction_context_t #foreign libsentry;

/**
* Sets the `name` on a Transaction Context, which will be used in the
* Transaction constructed off of the context.
*
* The Transaction Context should not be mutated by other functions while
* setting a name on it.
*/
sentry_transaction_context_set_name :: (tx_cxt: *sentry_transaction_context_t, name: *u8) -> void #foreign libsentry;

sentry_transaction_context_set_name_n :: (tx_cxt: *sentry_transaction_context_t, name: *u8, name_len: u64) -> void #foreign libsentry;

/**
* Sets the `operation` on a Transaction Context, which will be used in the
* Transaction constructed off of the context
*
* See https://develop.sentry.dev/sdk/performance/span-operations/ for
* conventions on `operation`s.
*
* The Transaction Context should not be mutated by other functions while
* setting an operation on it.
*/
sentry_transaction_context_set_operation :: (tx_cxt: *sentry_transaction_context_t, operation: *u8) -> void #foreign libsentry;

sentry_transaction_context_set_operation_n :: (tx_cxt: *sentry_transaction_context_t, operation: *u8, operation_len: u64) -> void #foreign libsentry;

/**
* Sets the `sampled` field on a Transaction Context, which will be used in the
* Transaction constructed off of the context.
*
* When passed any value above 0, the Transaction will bypass all sampling
* options and always be sent to sentry. If passed 0, this Transaction and its
* child spans will never be sent to sentry.
*
* The Transaction Context should not be mutated by other functions while
* setting `sampled` on it.
*/
sentry_transaction_context_set_sampled :: (tx_cxt: *sentry_transaction_context_t, sampled: s32) -> void #foreign libsentry;

/**
* Removes the `sampled` field on a Transaction Context, which will be used in
* the Transaction constructed off of the context.
*
* The Transaction will use the sampling rate as defined in `sentry_options`.
*
* The Transaction Context should not be mutated by other functions while
* removing `sampled`.
*/
sentry_transaction_context_remove_sampled :: (tx_cxt: *sentry_transaction_context_t) -> void #foreign libsentry;

/**
* Update the Transaction Context with the given HTTP header key/value pair.
*
* This is used to propagate distributed tracing metadata from upstream
* services. Therefore, the headers of incoming requests should be fed into this
* function so that sentry is able to continue a trace that was started by an
* upstream service.
*/
sentry_transaction_context_update_from_header :: (tx_cxt: *sentry_transaction_context_t, key: *u8, value: *u8) -> void #foreign libsentry;

sentry_transaction_context_update_from_header_n :: (tx_cxt: *sentry_transaction_context_t, key: *u8, key_len: u64, value: *u8, value_len: u64) -> void #foreign libsentry;

/**
* Starts a new Transaction based on the provided context, restored from an
* external integration (i.e. a span from a different SDK) or manually
* constructed by a user.
*
* The second parameter is a custom Sampling Context to be used with a Traces
* Sampler to make a more informed sampling decision. The SDK does not currently
* support a custom Traces Sampler and this parameter is ignored for the time
* being but needs to be provided.
*
* Returns a Transaction, which is expected to be manually managed by the
* caller. Manual management involves ensuring that `sentry_transaction_finish`
* is invoked for the Transaction, and that the caller manually starts and
* finishes any child Spans as needed on the Transaction.
*
* Not invoking `sentry_transaction_finish` with the returned Transaction means
* it will be discarded, and will not be sent to sentry.
*
* To ensure that any Events or Message Events are associated with this
* Transaction while it is active, invoke and pass in the Transaction returned
* by this function to `sentry_set_transaction_object`. Further documentation on
* this can be found in `sentry_set_transaction_object`'s docstring.
*
* Takes ownership of `transaction_context`. A Transaction Context cannot be
* modified or re-used after it is used to start a Transaction.
*
* The returned value is not thread-safe. Users are expected to ensure that
* appropriate locking mechanisms are implemented over the Transaction if it
* needs to be mutated across threads. Methods operating on the Transaction will
* mention what kind of expectations they carry if they need to mutate or access
* the object in a thread-safe way.
*/
sentry_transaction_start :: (tx_cxt: *sentry_transaction_context_t, sampling_ctx: sentry_value_t) -> *sentry_transaction_t #foreign libsentry;

/**
* Finishes and sends a Transaction to sentry. The event ID of the Transaction
* will be returned if this was successful; A nil UUID will be returned
* otherwise.
*
* Always takes ownership of `transaction`, regardless of whether the operation
* was successful or not. A Transaction cannot be modified or re-used after it
* is finished.
*/
sentry_transaction_finish :: (tx: *sentry_transaction_t) -> sentry_uuid_t #foreign libsentry;

/**
* Sets the Transaction so any Events sent while the Transaction
* is active will be associated with the Transaction.
*
* If the Transaction being passed in is unsampled, it will still be associated
* with any new Events. This will lead to some Events pointing to orphan or
* missing traces in sentry, see
* https://docs.sentry.io/product/sentry-basics/tracing/trace-view/#orphan-traces-and-broken-subtraces
*
* This increases the number of references pointing to the Transaction. Invoke
* `sentry_transaction_finish` to remove the Transaction set by this function as
* well as its reference by passing in the same Transaction as the one passed
* into this function.
*/
sentry_set_transaction_object :: (tx: *sentry_transaction_t) -> void #foreign libsentry;

/**
* Sets the Span so any Events sent while the Span
* is active will be associated with the Span.
*
* This increases the number of references pointing to the Span. Invoke
* `sentry_span_finish` to remove the Span set by this function as well
* as its reference by passing in the same Span as the one passed into
* this function.
*/
sentry_set_span :: (span: *sentry_span_t) -> void #foreign libsentry;

/**
* Starts a new Span.
*
* The return value of `sentry_transaction_start` should be passed in as
* `parent`.
*
* Both `operation` and `description` can be null, but it is recommended to
* supply the former. See
* https://develop.sentry.dev/sdk/performance/span-operations/ for conventions
* around operations.
*
* See https://develop.sentry.dev/sdk/event-payloads/span/ for a description of
* the created Span's properties and expectations for `operation` and
* `description`.
*
* Returns a value that should be passed into `sentry_span_finish`. Not
* finishing the Span means it will be discarded, and will not be sent to
* sentry. `sentry_value_null` will be returned if the child Span could not be
* created.
*
* To ensure that any Events or Message Events are associated with this
* Span while it is active, invoke and pass in the Span returned
* by this function to `sentry_set_span`. Further documentation on this can be
* found in `sentry_set_span`'s docstring.
*
* This increases the number of references pointing to the Transaction.
*
* The returned value is not thread-safe. Users are expected to ensure that
* appropriate locking mechanisms are implemented over the Span if it needs
* to be mutated across threads. Methods operating on the Span will mention what
* kind of expectations they carry if they need to mutate or access the object
* in a thread-safe way.
*/
sentry_transaction_start_child :: (parent: *sentry_transaction_t, operation: *u8, description: *u8) -> *sentry_span_t #foreign libsentry;

sentry_transaction_start_child_n :: (parent: *sentry_transaction_t, operation: *u8, operation_len: u64, description: *u8, description_len: u64) -> *sentry_span_t #foreign libsentry;

/**
* Starts a new Span.
*
* The return value of `sentry_span_start_child` may be passed in as `parent`.
*
* Both `operation` and `description` can be null, but it is recommended to
* supply the former. See
* https://develop.sentry.dev/sdk/performance/span-operations/ for conventions
* around operations.
*
* See https://develop.sentry.dev/sdk/event-payloads/span/ for a description of
* the created Span's properties and expectations for `operation` and
* `description`.
*
* Returns a value that should be passed into `sentry_span_finish`. Not
* finishing the Span means it will be discarded, and will not be sent to
* sentry. `sentry_value_null` will be returned if the child Span could not be
* created.
*
* To ensure that any Events or Message Events are associated with this
* Span while it is active, invoke and pass in the Span returned
* by this function to `sentry_set_span`. Further documentation on this can be
* found in `sentry_set_span`'s docstring.
*
* The returned value is not thread-safe. Users are expected to ensure that
* appropriate locking mechanisms are implemented over the Span if it needs
* to be mutated across threads. Methods operating on the Span will mention what
* kind of expectations they carry if they need to mutate or access the object
* in a thread-safe way.
*/
sentry_span_start_child :: (parent: *sentry_span_t, operation: *u8, description: *u8) -> *sentry_span_t #foreign libsentry;

sentry_span_start_child_n :: (parent: *sentry_span_t, operation: *u8, operation_len: u64, description: *u8, description_len: u64) -> *sentry_span_t #foreign libsentry;

/**
* Finishes a Span.
*
* This takes ownership of `span`. A Span cannot be modified or re-used after it
* is finished.
*
* This will mutate the `span`'s containing Transaction, so the containing
* Transaction should also not be mutated by other functions when finishing a
* span.
*/
sentry_span_finish :: (span: *sentry_span_t) -> void #foreign libsentry;

/**
* Sets a tag on a Transaction to the given string value.
*
* Tags longer than 200 bytes will be truncated.
*
* The Transaction should not be mutated by other functions while a tag is being
* set on it.
*/
sentry_transaction_set_tag :: (transaction: *sentry_transaction_t, tag: *u8, value: *u8) -> void #foreign libsentry;

sentry_transaction_set_tag_n :: (transaction: *sentry_transaction_t, tag: *u8, tag_len: u64, value: *u8, value_len: u64) -> void #foreign libsentry;

/**
* Removes a tag from a Transaction.
*
* The Transaction should not be mutated by other functions while a tag is being
* removed from it.
*/
sentry_transaction_remove_tag :: (transaction: *sentry_transaction_t, tag: *u8) -> void #foreign libsentry;

sentry_transaction_remove_tag_n :: (transaction: *sentry_transaction_t, tag: *u8, tag_len: u64) -> void #foreign libsentry;

/**
* Sets the given key in a Transaction's "data" section to the given value.
*
* The Transaction should not be mutated by other functions while data is being
* set on it.
*/
sentry_transaction_set_data :: (transaction: *sentry_transaction_t, key: *u8, value: sentry_value_t) -> void #foreign libsentry;

sentry_transaction_set_data_n :: (transaction: *sentry_transaction_t, key: *u8, key_len: u64, value: sentry_value_t) -> void #foreign libsentry;

/**
* Removes a key from a Transaction's "data" section.
*
* The Transaction should not be mutated by other functions while data is being
* removed from it.
*/
sentry_transaction_remove_data :: (transaction: *sentry_transaction_t, key: *u8) -> void #foreign libsentry;

sentry_transaction_remove_data_n :: (transaction: *sentry_transaction_t, key: *u8, key_len: u64) -> void #foreign libsentry;

/**
* Sets a tag on a Span to the given string value.
*
* Tags longer than 200 bytes will be truncated.
*
* The Span should not be mutated by other functions while a tag is being set on
* it.
*/
sentry_span_set_tag :: (span: *sentry_span_t, tag: *u8, value: *u8) -> void #foreign libsentry;

sentry_span_set_tag_n :: (span: *sentry_span_t, tag: *u8, tag_len: u64, value: *u8, value_len: u64) -> void #foreign libsentry;

/**
* Removes a tag from a Span.
*
* The Span should not be mutated by other functions while a tag is being
* removed from it.
*/
sentry_span_remove_tag :: (span: *sentry_span_t, tag: *u8) -> void #foreign libsentry;

sentry_span_remove_tag_n :: (span: *sentry_span_t, tag: *u8, tag_len: u64) -> void #foreign libsentry;

/**
* Sets the given key in a Span's "data" section to the given value.
*
* The Span should not be mutated by other functions while data is being set on
* it.
*/
sentry_span_set_data :: (span: *sentry_span_t, key: *u8, value: sentry_value_t) -> void #foreign libsentry;

sentry_span_set_data_n :: (span: *sentry_span_t, key: *u8, key_len: u64, value: sentry_value_t) -> void #foreign libsentry;

/**
* Removes a key from a Span's "data" section.
*
* The Span should not be mutated by other functions while data is being removed
* from it.
*/
sentry_span_remove_data :: (span: *sentry_span_t, key: *u8) -> void #foreign libsentry;

sentry_span_remove_data_n :: (span: *sentry_span_t, key: *u8, key_len: u64) -> void #foreign libsentry;

/**
* Sets a Transaction's name.
*
* The Transaction should not be mutated by other functions while setting its
* name.
*/
sentry_transaction_set_name :: (transaction: *sentry_transaction_t, name: *u8) -> void #foreign libsentry;

sentry_transaction_set_name_n :: (transaction: *sentry_transaction_t, name: *u8, name_len: u64) -> void #foreign libsentry;

/**
* Creates a new User Feedback with a specific name, email and comments.
*
* See https://develop.sentry.dev/sdk/envelopes/#user-feedback
*
* User Feedback has to be associated with a specific event that has been
* sent to Sentry earlier.
*/
sentry_value_new_user_feedback :: (uuid: *sentry_uuid_t, name: *u8, email: *u8, comments: *u8) -> sentry_value_t #foreign libsentry;

sentry_value_new_user_feedback_n :: (uuid: *sentry_uuid_t, name: *u8, name_len: u64, email: *u8, email_len: u64, comments: *u8, comments_len: u64) -> sentry_value_t #foreign libsentry;

/**
* Captures a manually created User Feedback and sends it to Sentry.
*/
sentry_capture_user_feedback :: (user_feedback: sentry_value_t) -> void #foreign libsentry;

/**
* The status of a Span or Transaction.
*
* See https://develop.sentry.dev/sdk/event-payloads/span/ for documentation.
*/
sentry_span_status_t :: enum u32 {
    OK                  :: 0;

    CANCELLED           :: 1;

    UNKNOWN             :: 2;

    INVALID_ARGUMENT    :: 3;

    DEADLINE_EXCEEDED   :: 4;

    NOT_FOUND           :: 5;

    ALREADY_EXISTS      :: 6;

    PERMISSION_DENIED   :: 7;

    RESOURCE_EXHAUSTED  :: 8;

    FAILED_PRECONDITION :: 9;

    ABORTED             :: 10;

    OUT_OF_RANGE        :: 11;

    UNIMPLEMENTED       :: 12;

    INTERNAL_ERROR      :: 13;

    UNAVAILABLE         :: 14;

    DATA_LOSS           :: 15;

    UNAUTHENTICATED     :: 16;

    SENTRY_SPAN_STATUS_OK                  :: OK;

    SENTRY_SPAN_STATUS_CANCELLED           :: CANCELLED;

    SENTRY_SPAN_STATUS_UNKNOWN             :: UNKNOWN;

    SENTRY_SPAN_STATUS_INVALID_ARGUMENT    :: INVALID_ARGUMENT;

    SENTRY_SPAN_STATUS_DEADLINE_EXCEEDED   :: DEADLINE_EXCEEDED;

    SENTRY_SPAN_STATUS_NOT_FOUND           :: NOT_FOUND;

    SENTRY_SPAN_STATUS_ALREADY_EXISTS      :: ALREADY_EXISTS;

    SENTRY_SPAN_STATUS_PERMISSION_DENIED   :: PERMISSION_DENIED;

    SENTRY_SPAN_STATUS_RESOURCE_EXHAUSTED  :: RESOURCE_EXHAUSTED;

    SENTRY_SPAN_STATUS_FAILED_PRECONDITION :: FAILED_PRECONDITION;

    SENTRY_SPAN_STATUS_ABORTED             :: ABORTED;

    SENTRY_SPAN_STATUS_OUT_OF_RANGE        :: OUT_OF_RANGE;

    SENTRY_SPAN_STATUS_UNIMPLEMENTED       :: UNIMPLEMENTED;

    SENTRY_SPAN_STATUS_INTERNAL_ERROR      :: INTERNAL_ERROR;

    SENTRY_SPAN_STATUS_UNAVAILABLE         :: UNAVAILABLE;

    SENTRY_SPAN_STATUS_DATA_LOSS           :: DATA_LOSS;

    SENTRY_SPAN_STATUS_UNAUTHENTICATED     :: UNAUTHENTICATED;
}

/**
* Sets a Span's status.
*
* The Span should not be mutated by other functions while setting its status.
*/
sentry_span_set_status :: (span: *sentry_span_t, status: sentry_span_status_t) -> void #foreign libsentry;

/**
* Sets a Transaction's status.
*
* The Transaction should not be mutated by other functions while setting its
* status.
*/
sentry_transaction_set_status :: (tx: *sentry_transaction_t, status: sentry_span_status_t) -> void #foreign libsentry;

/**
* Type of the `iter_headers` callback.
*
* The callback is being called with HTTP header key/value pairs.
* These headers can be attached to outgoing HTTP requests to propagate
* distributed tracing metadata to downstream services.
*
*/
sentry_iter_headers_function_t :: #type (key: *u8, value: *u8, userdata: *void) -> void #c_call;

/**
* Iterates the distributed tracing HTTP headers for the given span.
*/
sentry_span_iter_headers :: (span: *sentry_span_t, callback: sentry_iter_headers_function_t, userdata: *void) -> void #foreign libsentry;

/**
* Iterates the distributed tracing HTTP headers for the given transaction.
*/
sentry_transaction_iter_headers :: (tx: *sentry_transaction_t, callback: sentry_iter_headers_function_t, userdata: *void) -> void #foreign libsentry;

/**
* Returns whether the application has crashed on the last run.
*
* Notes:
*   * The underlying value is set by sentry_init() - it must be called first.
*   * Call sentry_clear_crashed_last_run() to reset for the next app run.
*
* Possible return values:
*   1 = the last run was a crash
*   0 = no crash recognized
*  -1 = sentry_init() hasn't been called yet
*/
sentry_get_crashed_last_run :: () -> s32 #foreign libsentry;

/**
* Clear the status of the "crashed-last-run". You should explicitly call
* this after sentry_init() if you're using sentry_get_crashed_last_run().
* Otherwise, the same information is reported on any subsequent runs.
*
* Notes:
*   * This doesn't change the value of sentry_get_crashed_last_run() yet.
*     However, if sentry_init() is called again, the value will change.
*   * This may only be called after sentry_init() and before sentry_close().
*
* Returns 0 on success, 1 on error.
*/
sentry_clear_crashed_last_run :: () -> s32 #foreign libsentry;

/**
* Sentry SDK version.
*/
sentry_sdk_version :: () -> *u8 #foreign libsentry;

/**
* Sentry SDK name set during build time.
* Deprecated: Please use sentry_options_get_sdk_name instead.
*/
sentry_sdk_name :: () -> *u8 #foreign libsentry;

/**
* Sentry SDK User-Agent set during build time.
* Deprecated: Please use sentry_options_get_user_agent instead.
*/
sentry_sdk_user_agent :: () -> *u8 #foreign libsentry;

#scope_file

#import "Basic"; // For push_context

libsentry :: #library "sentry-native/build/libsentry";
