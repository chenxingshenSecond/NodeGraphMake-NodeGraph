function writeObj(fname, obj)
%
% INPUT: fname - wavefront object file full path
%
%        obj:
%          obj.v - mesh vertices
%          obj.vt - texture coordinates
%          obj.vn - normal coordinates
%          obj.f - face definition assuming faces are made of of 3 vertices
%

fid = fopen(fname, 'w');

num_v = size(obj.v, 1);
fprintf(fid, '# %d vertices\n', num_v);
for v = 1 : num_v
    fprintf(fid, 'v %f %f %f\n', obj.v(v, :));
end
fprintf(fid, '\n');

num_f = size(obj.f.v, 1);
fprintf(fid, '# %d faces\n', num_f);
for f = 1 : num_f
    fprintf(fid, 'f %d %d %d\n', obj.f.v(f, :));
end
fprintf(fid, '\n');

fclose(fid);

end
