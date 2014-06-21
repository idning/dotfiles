struct ngx_command_t {
    ngx_str_t name;
    ngx_uint_t type;
    ngx_uint_t conf;
    ngx_uint_t offset;
    void  *post;
    char set(ngx_conf_t *cf, ngx_command_t *cmd, void *conf);
};

struct ngx_open_file_t {
    ngx_fd_t fd;
    ngx_str_t name;
    u_char *buffer;
    u_char *pos;
    u_char *last;
};


struct ngx_module_t {
    ngx_uint_t ctx_index;
    ngx_uint_t index;

    ngx_uint_t spare0;
    ngx_uint_t spare1;
    ngx_uint_t spare2;
    ngx_uint_t spare3;

    ngx_uint_t version;

    void  *ctx;
    ngx_command_t *commands;
    ngx_uint_t type;

    ngx_int_t init_master(ngx_log_t *log);
    ngx_int_t init_module(ngx_cycle_t *cycle);
    ngx_int_t init_process(ngx_cycle_t *cycle);
    ngx_int_t init_thread(ngx_cycle_t *cycle);
    void exit_thread(ngx_cycle_t *cycle);
    void exit_process(ngx_cycle_t *cycle);
    void exit_master(ngx_cycle_t *cycle);

    uintptr_t spare_hook0;
    uintptr_t spare_hook1;
    uintptr_t spare_hook2;
    uintptr_t spare_hook3;
    uintptr_t spare_hook4;
    uintptr_t spare_hook5;
    uintptr_t spare_hook6;
    uintptr_t spare_hook7;


};


struct ngx_core_module_t{
    ngx_str_t name;
    void create_conf(ngx_cycle_t *cycle);
    char init_conf(ngx_cycle_t *cycle, void *conf);
} ;


struct ngx_conf_file_t{
    ngx_file_t file;
    ngx_buf_t *buffer;
    ngx_uint_t line;
} ;


struct ngx_conf_t {
    char  *name;
    ngx_array_t *args;

    ngx_cycle_t *cycle;
    ngx_pool_t *pool;
    ngx_pool_t *temp_pool;
    ngx_conf_file_t *conf_file;
    ngx_log_t *log;

    void  *ctx;
    ngx_uint_t module_type;
    ngx_uint_t cmd_type;

    char  *handler_conf;
    char *handler(ngx_conf_t *cf, ngx_command_t *dummy, void *conf)
};


struct ngx_conf_post_t{
    ngx_conf_post_handler_pt post_handler;
} ;


struct ngx_conf_deprecated_t{
    ngx_conf_post_handler_pt post_handler;
    char  *old_name;
    char  *new_name;
};


struct ngx_conf_num_bounds_t{
    ngx_conf_post_handler_pt post_handler;
    ngx_int_t  low;
    ngx_int_t  high;
} ;


struct ngx_conf_enum_t{
    ngx_str_t  name;
    ngx_uint_t value;
} ;


struct ngx_conf_bitmask_t{
    ngx_str_t  name;
    tgx_uint_t mask;
} ;



