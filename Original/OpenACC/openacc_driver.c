#include "../driver.h"
#include "openacc_propagate.h"
#include "openacc_insertsource.h"
#include "../sample.h"

void DRIVER_Initialize(const int sx, const int sy, const int sz, const int bord,
		       float dx, float dy, float dz, float dt,
		       float * restrict vpz, float * restrict vsv, float * restrict epsilon, float * restrict delta,
		       float * restrict phi, float * restrict theta,
		       float * restrict pp, float * restrict pc, float * restrict qp, float * restrict qc)
{

  extern float* ch1dxx;
#pragma acc enter data copyin(ch1dxx[0:sx*sy*sz])
  extern float* ch1dyy;
#pragma acc enter data copyin(ch1dyy[0:sx*sy*sz])
  extern float* ch1dzz;
#pragma acc enter data copyin(ch1dzz[0:sx*sy*sz])
  extern float* ch1dxy;
#pragma acc enter data copyin(ch1dxy[0:sx*sy*sz])
  extern float* ch1dyz;
#pragma acc enter data copyin(ch1dyz[0:sx*sy*sz])
  extern float* ch1dxz;
#pragma acc enter data copyin(ch1dxz[0:sx*sy*sz])
  extern float* v2px;
#pragma acc enter data copyin(  v2px[0:sx*sy*sz])
  extern float* v2pz;
#pragma acc enter data copyin(  v2pz[0:sx*sy*sz])
  extern float* v2sz;
#pragma acc enter data copyin(  v2sz[0:sx*sy*sz])
  extern float* v2pn;
#pragma acc enter data copyin(  v2pn[0:sx*sy*sz])

#pragma acc enter data copyin(pp[0:sx*sy*sz])
#pragma acc enter data copyin(pc[0:sx*sy*sz])
#pragma acc enter data copyin(qp[0:sx*sy*sz])
#pragma acc enter data copyin(qc[0:sx*sy*sz])

}



void DRIVER_Finalize()
{
}


void DRIVER_Update_pointers(const int sx, const int sy, const int sz, float *pc)
{

#pragma acc update host(pc[0:sx*sy*sz])

}


void DRIVER_Propagate(const int sx, const int sy, const int sz, const int bord,
	       const float dx, const float dy, const float dz, const float dt, const int it, 
	       float * restrict pp, float * restrict pc, float * restrict qp, float * restrict qc)
{

	   OPENACC_Propagate (  sx,   sy,   sz,   bord,
	                              dx,   dy,   dz,   dt,   it,
	                              pp,   pc,   qp,   qc);

}


void DRIVER_InsertSource(float dt, int it, int iSource, float *p, float*q, float src)
{

	        OPENACC_InsertSource(dt,it,iSource,p,q, src);

}

