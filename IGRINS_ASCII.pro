PRO IGRINS_ASCII,filenumber,wavefilenum,band

fn=string(filenumber,format='(I04)')
wfn=string(wavefilenum,format='(I04)')
outprefix=''
wavefile = FILE_SEARCH('SDC'+band+'_*_'+wfn+'.wvlsol_v1.fits')
specfile = FILE_SEARCH('SDC'+band+'_*_'+fn+'.spec.fits')
snrfile = FILE_SEARCH('SDC'+band+'_*_'+fn+'.sn.fits')
varfile = FILE_SEARCH('SDC'+band+'_*_'+fn+'.variance.fits')

print,'Enter the output prefix: XXXXXXXX_band_filenumber.txt'
read,outprefix
outname=outprefix+'_'+band+'_'+fn+'.txt'

wave=readfits(wavefile(0),hdr)
spec=readfits(specfile(0),hdr)
snr=readfits(snrfile(0),hdr)
var=readfits(varfile(0),hdr)


norders=size(wave)
outfilesize=2048*norders(2)
merge=fltarr(4,outfilesize)

j = norders(2)-1
for i = 0,norders(2)-1 do begin
   print,i
   row = (j-i)*2048
   merge(0,row:row+2047)=wave(*,i)
   merge(1,row:row+2047)=spec(*,i)
   merge(2,row:row+2047)=snr(*,i)
   merge(3,row:row+2047)=var(*,i)
endfor

openw,1,outname
printf,1,'# Generated by G. Mace on '+SYSTIME()
printf,1,'# Wavelengths are not sequential where orders overlap.'
printf,1,'# Each order is 2048 pixels.'
printf,1,'#======================================================'
printf,1,'# Wavelength         Flux         SNR           Variance   '
printf,1,'# (microns)        (counts)    (per res.el.)   (ignore)'
printf,1,'#======================================================'
printf,1,merge
close,1

print,'ASCII file has been saved with all orders,2048 rows each, in a sigle file.'
print,'Output file:    ',outname

END