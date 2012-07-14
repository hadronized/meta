module meta.models.plane;

private {
	import meta.models.mesh;
	import meta.math.vecs;
}
public {
}


/* define the used vertex */
alias vec2 space_co2;

struct sco2_uv1_vertex {
    space_co2 sco;
    uv_co uv;

	this(space_co2 sco, uv_co uv) {
		this.sco = sco;
		this.uv = uv;
	}
}

/* define the mesh used as plane */
alias mesh!sco2_uv1_vertex plane_mesh;

/* define the plane */
class plane : plane_mesh {
    this(float w, float h) {
        immutable w_2 = w / 2;
        immutable h_2 = h / 2;

        auto sco = [
            space_co2(-w_2, -h_2),
            space_co2(-w_2,  h_2),
            space_co2( w_2,  h_2),
            space_co2( w_2, -h_2)
        ];
        auto uv = [
            uv_co(0.0f, 1.0f),
            uv_co(0.0f, 0.0f),
            uv_co(1.0f, 0.0f),
            uv_co(1.0f, 1.0f)
        ];

        foreach (i; 0..4)
            add_vertex( vertex_t(sco[i], uv[i]) );
	}

	@property {
		float width() const {
			vec2 v1, v2;
			auto v3 = v1 - v2;
			return (_vertices[0u].sco - _vertices[3u].sco).norm;
		}

		float height() const {
			return (_vertices[0u].sco - _vertices[1u].sco).norm;
		}
	}
}
