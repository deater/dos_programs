struct st_readp
{
	int	magic;
	int	wid;
	int	hig;
	int	cols;
	int	add;
};

void readp(char *dest, int row, char *src);
