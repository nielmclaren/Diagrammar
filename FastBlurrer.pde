
class FastBlurrer {
  int w;
  int h;
  int radius;

  int wm;
  int hm;
  int wh;
  int div;
  int[] r;
  int[] g;
  int[] b;
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int[] vmin;
  int[] vmax;
  int[] dv;

  FastBlurrer(int _width, int _height, int _radius) {
    w = _width;
    h = _height;
    radius = _radius;

    wm = w-1;
    hm = h-1;
    wh = w*h;
    div = radius+radius+1;
    r = new int[wh];
    g = new int[wh];
    b = new int[wh];
    vmin = new int[max(w,h)];
    vmax = new int[max(w,h)];
    dv = new int[256*div];
  }

  /**
   * Thanks Mario!
   * @see http://incubator.quasimondo.com/processing/superfastblur.pde
   */
  void blur(color[] pixels) {
    if (radius < 1) return;

    for (i=0;i<256*div;i++){
      dv[i]=(i/div);
    }

    yw=yi=0;

    for (y=0;y<h;y++){
      rsum=gsum=bsum=0;
      for(i=-radius;i<=radius;i++){
        p=pixels[yi+min(wm,max(i,0))];
        rsum+=(p & 0xff0000)>>16;
        gsum+=(p & 0x00ff00)>>8;
        bsum+= p & 0x0000ff;
      }
      for (x=0;x<w;x++){

        r[yi]=dv[rsum];
        g[yi]=dv[gsum];
        b[yi]=dv[bsum];

        if(y==0){
          vmin[x]=min(x+radius+1,wm);
          vmax[x]=max(x-radius,0);
        }
        p1=pixels[yw+vmin[x]];
        p2=pixels[yw+vmax[x]];

        rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
        gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
        bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
        yi++;
      }
      yw+=w;
    }

    for (x=0;x<w;x++){
      rsum=gsum=bsum=0;
      yp=-radius*w;
      for(i=-radius;i<=radius;i++){
        yi=max(0,yp)+x;
        rsum+=r[yi];
        gsum+=g[yi];
        bsum+=b[yi];
        yp+=w;
      }
      yi=x;
      for (y=0;y<h;y++){
        pixels[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
        if(x==0){
          vmin[y]=min(y+radius+1,hm)*w;
          vmax[y]=max(y-radius,0)*w;
        }
        p1=x+vmin[y];
        p2=x+vmax[y];

        rsum+=r[p1]-r[p2];
        gsum+=g[p1]-g[p2];
        bsum+=b[p1]-b[p2];

        yi+=w;
      }
    }
  }
}
