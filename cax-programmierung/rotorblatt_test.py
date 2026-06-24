import build123d as bd
import pytest

from rotorblatt import (
    BladeParam,
    _circular_face_aligned,
    naca_points,
    pts_to_face,
)


class TestNacaPoints:
    def test_returns_python_floats(self) -> None:
        pts = naca_points("4418")
        assert all(isinstance(x, float) and isinstance(y, float) for x, y in pts)

    def test_leading_edge_at_origin(self) -> None:
        x, y = naca_points("4418")[0]
        assert x == pytest.approx(0.0, abs=1e-6)

    def test_trailing_edge_closed(self) -> None:
        pts = naca_points("4418")
        te = max(pts, key=lambda p: p[0])
        assert te[0] == pytest.approx(1.0, abs=1e-6)

    def test_all_x_in_unit_interval(self) -> None:
        for x, _ in naca_points("2412"):
            assert 0.0 <= x <= 1.0 + 1e-9

    def test_symmetric_profile_zero_camber(self) -> None:
        pts = naca_points("0018")
        te_idx = max(range(len(pts)), key=lambda i: pts[i][0])
        upper = pts[1:te_idx]  # skip LE, stop before TE
        lower = list(reversed(pts[te_idx + 1 :]))  # near-LE to near-TE
        assert len(upper) == len(lower)
        for (xu, yu), (xl, yl) in zip(upper, lower):
            assert xu == pytest.approx(xl, abs=1e-6)
            assert yu == pytest.approx(-yl, abs=1e-6)

    def test_trailing_edge_y_is_zero_for_symmetric(self) -> None:
        te_x, te_y = max(naca_points("0012"), key=lambda p: p[0])
        assert te_x == pytest.approx(1.0, abs=1e-6)
        assert te_y == pytest.approx(0.0, abs=1e-6)

    def test_point_count_scales_with_n(self) -> None:
        assert len(naca_points("0012", n=30)) < len(naca_points("0012", n=60))


class TestPtsToFace:
    @pytest.fixture
    def simple_face(self) -> bd.Face:
        pts = naca_points("0012")
        return pts_to_face(pts, r=10.0, chord=100.0, twist_deg=0.0)

    def test_returns_face(self, simple_face: bd.Face) -> None:
        assert isinstance(simple_face, bd.Face)

    def test_face_at_correct_z(self, simple_face: bd.Face) -> None:
        bb = simple_face.bounding_box()
        assert bb.min.Z == pytest.approx(10.0, abs=1e-3)
        assert bb.max.Z == pytest.approx(10.0, abs=1e-3)

    def test_chord_spans_full_width(self, simple_face: bd.Face) -> None:
        bb = simple_face.bounding_box()
        assert bb.size.X == pytest.approx(100.0, rel=0.01)

    def test_twist_rotates_face(self) -> None:
        pts = naca_points("0012")
        face_0 = pts_to_face(pts, r=0.0, chord=100.0, twist_deg=0.0)
        face_90 = pts_to_face(pts, r=0.0, chord=100.0, twist_deg=90.0)
        bb_0 = face_0.bounding_box()
        bb_90 = face_90.bounding_box()
        assert bb_0.size.X == pytest.approx(bb_90.size.Y, rel=0.01)
        assert bb_0.size.Y == pytest.approx(bb_90.size.X, rel=0.01)

    def test_chord_scales_face(self) -> None:
        pts = naca_points("0012")
        face_small = pts_to_face(pts, r=0.0, chord=50.0, twist_deg=0.0)
        face_large = pts_to_face(pts, r=0.0, chord=200.0, twist_deg=0.0)
        ratio = face_large.bounding_box().size.X / face_small.bounding_box().size.X
        assert ratio == pytest.approx(4.0, rel=0.01)


class TestCircularFaceAligned:
    @pytest.fixture
    def circle(self) -> bd.Face:
        return _circular_face_aligned(r=5.0, radius=100.0, twist_deg=0.0)

    def test_returns_face(self, circle: bd.Face) -> None:
        assert isinstance(circle, bd.Face)

    def test_face_at_correct_z(self, circle: bd.Face) -> None:
        bb = circle.bounding_box()
        assert bb.min.Z == pytest.approx(5.0, abs=1e-3)
        assert bb.max.Z == pytest.approx(5.0, abs=1e-3)

    def test_bounding_box_matches_diameter(self, circle: bd.Face) -> None:
        bb = circle.bounding_box()
        assert bb.size.X == pytest.approx(200.0, rel=0.01)
        assert bb.size.Y == pytest.approx(200.0, rel=0.01)

    def test_is_round(self, circle: bd.Face) -> None:
        bb = circle.bounding_box()
        assert bb.size.X == pytest.approx(bb.size.Y, rel=1e-4)


class TestBladeParam:
    def test_defaults_are_positive(self) -> None:
        p = BladeParam()
        for field_name in (
            "span",
            "chord_max",
            "chord_tip",
            "r_shoulder",
            "flange_radius",
            "flange_length",
            "n_sections",
        ):
            assert getattr(p, field_name) > 0

    def test_shoulder_inside_span(self) -> None:
        p = BladeParam()
        assert p.flange_length < p.r_shoulder < p.span

    def test_chord_decreases_from_max_to_tip(self) -> None:
        p = BladeParam()
        assert p.chord_tip < p.chord_max

    def test_twist_decreases_root_to_tip(self) -> None:
        p = BladeParam()
        assert p.twist_tip < p.twist_root
