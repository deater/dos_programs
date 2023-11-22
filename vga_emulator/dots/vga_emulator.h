extern unsigned char framebuffer[320*200];

struct palette {
        unsigned char red[256];
        unsigned char green[256];
        unsigned char blue[256];
};

int mode13h_graphics_init(char *name);
int mode13h_graphics_update(void);
void set_default_pal(void);
int graphics_input(void);
void write_framebuffer(int address, int value);

void outp(short address, int value);
int inp(short addr);
