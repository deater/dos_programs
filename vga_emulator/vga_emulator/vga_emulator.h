extern unsigned char framebuffer[65536*4];

extern int vga_map_mask;

struct palette {
        unsigned char red[256];
        unsigned char green[256];
        unsigned char blue[256];
};

int mode13h_graphics_init(char *name, int scale);
int mode13h_graphics_update(void);

void set_default_pal(void);
void set_pal(int which, int r, int g, int b);
void get_pal(int which, unsigned char *dest);

int graphics_input(void);

void framebuffer_write_20bit(int address, int value);
void framebuffer_write(int address, int value);
void framebuffer_putpixel(int x, int y, int color);

void outp(short address, int value);
int inp(short addr);

int int10h(int ax, int cx, int dx);
