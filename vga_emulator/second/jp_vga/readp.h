struct st_readp
{
	int16_t	magic;
	int16_t	width;
	int16_t	height;
	int16_t	colors;
	int16_t	add;
};

void readp(unsigned char *dest, int row, unsigned char *src);
