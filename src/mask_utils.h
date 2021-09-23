#include "mask_api.h"

class RLEVec
{
private:
    RLE * _R;
    size_t	_n;

public:
    RLEVec(siz n);
    
public:
    void dealloc();
    siz	size();
};

class MaskVec
{
private:
    size_t	_h;
    size_t	_w;
    size_t	_n;

    char * _mask;

public:
    MaskVec(size_t h, size_t w, size_t n);

public:
    size_t		mask_cnt();
    char * 	mask_vec();
};
