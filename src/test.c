#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <png.h>

#include "mask_api.h"
#include "leb128.h"

#define ERROR -1

int main(int argc, char ** argv)
{
  RLE rle;
  LEB128 * leb;
  siz h = 320;
  siz w = 480;
  siz m = 0;
  unsigned char * counts = "bfa2`0R8a1J4M4M2O1N1O2O1N101O0O2O000O2O00001O0O10001O000000001N100000000000000000000001O0000000000000O101O00000O101O000O101N100O2O0O1L5G8O2N1O2O1F:D<C=DXa]1";
  unsigned char * mo;
  char * ms;
  FILE * f;
  int i, c = 0;

  m = strlen(counts);
  //leb = leb128Decode(counts, m);
  mo = (unsigned char *)calloc((h * w), sizeof(byte));

  rleFrString(&rle, (char *)counts, h, w);
  for (i = 0; i < rle.m; i++)
  {
      c += rle.cnts[i];
  }
  rleDecode(&rle, mo, 1);
  for (i = 0; i < c; i++)
  {
      if (*(mo + i))
          *(mo + i) = 255;
      printf("%d ", (int)*(mo + i));
      if (((i + 1) % w) == 0) printf("\n");
  }

  //ms = rleToString(&rle);
  //printf("rleToString:\n%s\n", ms);

  /* ---------------------------png------------------------------ */
  f = fopen("data.raw", "wb+");
  if (f == NULL)
      return ERROR;

  png_structp png_ptr = png_create_write_struct
      (PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

  if (!png_ptr)
      return ERROR;

  png_infop info_ptr = png_create_info_struct(png_ptr);

  if (!info_ptr)
  {
      png_destroy_read_struct(&png_ptr,
                              (png_infopp)NULL, (png_infopp)NULL);
      return ERROR;
  }

  png_set_IHDR(png_ptr, info_ptr, w, h,
               8, PNG_COLOR_TYPE_GRAY, PNG_INTERLACE_NONE,
               PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
  png_init_io(png_ptr, f);
  //png_set_packing(png_ptr);
  png_write_info(png_ptr,info_ptr);

  png_bytep row_pointers[320];
  for (i = 0; i < h; i++)
      row_pointers[i] = (png_bytep)(mo + 480 * i);

  png_write_image(png_ptr, row_pointers);
  png_write_end(png_ptr, info_ptr);
  png_destroy_write_struct(&png_ptr, &info_ptr);
  fclose(f);
  /* -------------------------png-----------------------------------*/
  printf("write done\n");

  free(mo);
  rleFree(&rle);
  //leb128Free(leb);

  return 0;
}
