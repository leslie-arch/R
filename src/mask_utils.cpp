#include <assert.h>
#include <string>
#include <Rcpp.h>

#include "mask_api.h"
#include "mask_utils.h"

/*********** class RLEVec ***********/
RLEVec::RLEVec(size_t n):_n(n)
{
    rlesInit(&this->_R, n);
}

void RLEVec::dealloc()
{
    int i;

    if(this->_n == 0)
        return;

    for (i = 0; i < this->_n; i++)
    {
        rleFree(this->_R + i);
    }

    free(this->_R);
}

//[[Rcpp::export]]
Rcpp::XPtr<RLEVec> new_RLEVec(size_t n)
{
    //size_t tn = Rcpp::as<unsigned long>(n);
    RLEVec * t = new RLEVec(n);

    Rcpp::XPtr<RLEVec> ptr(t, true);
    return ptr;
}

/**************** class MaskVec *****************/
MaskVec::MaskVec(size_t h, size_t w, size_t n):
    _h(h),
    _w(w),
    _n(n)
{
    this->_mask = (char *)malloc(h * w * n * sizeof(char));
}

size_t MaskVec::mask_cnt()
{
    return this->_n;
}

char * MaskVec::mask_vec()
{
    return this->_mask;
}

RLEs _fromString(Rcpp::List objs)
{
    size_t n = objs.size();
    char * c_string = NULL;
    
}

//[[Rcpp::export]]
Rcpp::RawVector mask_utils_decode(size_t h, size_t w, const char * counts)
{
  RLE rle;
  size_t m = 0;
  unsigned char * mo = NULL;
  int i, j, id;

  assert((h > 0) & (w > 0) & (counts != NULL));

  mo = (unsigned char *)calloc((h * w), sizeof(byte));

  rleFrString(&rle, (char *)counts, h, w);

  rleDecode(&rle, mo, 1);

  rleFree(&rle);

  Rcpp::RawVector v(mo, mo + h * w);
  std::vector<std::string> attrs = v.attributeNames();
  std::vector<std::string>::iterator it = attrs.begin();
  while (it != attrs.end())
      std::cout << "attribute: " << *it << std::endl;
  v.attr("dim") = Rcpp::Dimension(h, w);
  std::cout << "vector<char *> size : " << v.size() << std::endl;

  return v;
}

//[[Rcpp::export]]
std::string mask_utils_test(Rcpp::List t)
{
    int x;
    int i;

    std::cout << "param(t) size : " << t.size() << std::endl;
    Rcpp::List lx = Rcpp::as<Rcpp::List>(t["size"]);
    x = Rcpp::as<int>(lx[0]);
    std::string sc = Rcpp::as<std::string>(t["counts"]);

    std::cout << "t$size[1] :" << x << std::endl
         << "t$counts :" << sc << std::endl;

    //Rcpp::IntegerVector t
    return std::string("xxbbxxcc");
}
