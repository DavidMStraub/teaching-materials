from dataclasses import dataclass, field

import build123d as bd
import numpy as np


NacaPoints = list[tuple[float, float]]
"""Normalised 2-D airfoil outline: closed sequence of (x, y) points in [0,1]²."""


@dataclass
class BladeParam:
    """Parameters for a simplified 2-MW onshore wind turbine rotor blade.

    All lengths are stored in millimetres (build123d internal unit).
    Use the bd.M / bd.CM / bd.MM constants when setting values.
    """

    span: float = 45.0 * bd.M
    """Total blade length in millimetres."""

    chord_max: float = 3.5 * bd.M
    """Maximum chord length at the shoulder in millimetres."""

    chord_tip: float = 50.0 * bd.CM
    """Chord length at the blade tip in millimetres."""

    r_shoulder: float = 12.0 * bd.M
    """Spanwise position of maximum chord in millimetres."""

    twist_root: float = 20.0
    """Twist angle at the blade root in degrees."""

    twist_tip: float = 3.0
    """Twist angle at the blade tip in degrees."""

    naca_root: str = "2060"
    """NACA 4-digit profile code at the blade root."""

    naca_tip: str = "6418"
    """NACA 4-digit profile code at the blade tip."""

    n_sections: int = 10
    """Number of loft cross-sections along the span."""

    flange_radius: float = 80.0 * bd.CM
    """Radius of the cylindrical root flange in millimetres."""

    flange_length: float = 150.0 * bd.CM
    """Length of the cylindrical root flange in millimetres."""


@dataclass
class StructureParam:
    """Internal structural parameters for the rotor blade.

    Decoupled from BladeParam so that aerodynamic geometry and structural layout
    can be varied independently — e.g. in a structural optimisation loop.
    All lengths in millimetres.
    """

    wall_thickness: float = 15.0 * bd.MM
    """Shell wall thickness of the aerodynamic blade surface.
    Typical GFK sandwich laminate on a 45 m blade: 10–20 mm."""

    root_wall_thickness: float = 80.0 * bd.MM
    """Wall thickness of the cylindrical root flange.
    Root carries the highest bending loads — typical value 60–100 mm."""

    spar_positions: list[float] = field(default_factory=lambda: [0.25, 0.60])
    """Chordwise positions of spar webs as fractions of chord length [0, 1].
    Length of this list determines the number of spars."""

    spar_thickness: float = 50.0 * bd.MM
    """Web thickness of each spar in millimetres."""


def _naca_compute(m: float, p: float, t: float, n: int) -> NacaPoints:
    """Compute a closed NACA 4-digit profile outline using the approximate thickness formula.

    Thickness is added vertically (perpendicular to chord, not to camber line), which
    keeps all sections' x-coordinates consistent across varying thicknesses and prevents
    loft parameterisation artefacts near the leading edge.

    Points are cosine-spaced, run LE → TE on the upper surface, then TE → LE on the
    lower surface (excluding the shared endpoints), forming a single closed polygon.
    The trailing edge is forced closed (zero thickness at x = 1).

    Args:
        m: Maximum camber as a fraction of chord.
        p: Chordwise position of maximum camber (0 < p < 1).
        t: Maximum thickness as a fraction of chord.
        n: Number of cosine-spaced intervals per surface side.
    """
    # Cosine spacing concentrates points near LE and TE where curvature is highest.
    # Uniform spacing would undersample the nose and produce a faceted leading edge.
    beta = np.linspace(0.0, np.pi, n + 1)
    x = (1.0 - np.cos(beta)) / 2.0

    # Standard NACA 4-digit thickness distribution. The -0.1036 coefficient (instead
    # of the original -0.1015) forces yt = 0 at x = 1, giving a closed trailing edge.
    yt = (t / 0.2) * (
        0.2969 * np.sqrt(x) - 0.1260 * x - 0.3516 * x**2 + 0.2843 * x**3 - 0.1036 * x**4
    )

    # Camber line: two parabolic arcs joined at the point of maximum camber x = p.
    if m > 0.0 and p > 0.0:
        yc = np.where(
            x < p,
            m / p**2 * (2 * p * x - x**2),
            m / (1 - p) ** 2 * (1 - 2 * p + 2 * p * x - x**2),
        )
    else:
        yc = np.zeros_like(x)

    # Approximate formula: thickness added vertically, not normal to camber line.
    # This means every section's i-th point sits at the same chord fraction x_i,
    # which is essential for consistent loft parameterisation across varying thicknesses.
    upper = [(float(a), float(b)) for a, b in zip(x, yc + yt)]
    lower = [(float(a), float(b)) for a, b in zip(x, yc - yt)]

    # Remove the cluster of near-TE points from cosine spacing (x > 0.97) to avoid
    # a degenerate spline segment, then re-attach the exact TE point (x = 1).
    cutoff = 0.97
    upper = [pt for pt in upper if pt[0] <= cutoff] + [upper[-1]]
    lower = [pt for pt in lower if pt[0] <= cutoff] + [lower[-1]]

    # Combine into a single closed outline: upper LE→TE, then lower TE→LE.
    # lower[-2:0:-1] reverses the lower list, skipping the shared TE and LE endpoints.
    return upper + lower[-2:0:-1]


def _parse_naca(digits: str) -> tuple[float, float, float]:
    """Parse a NACA 4-digit code into continuous parameters (m, p, t).

    Args:
        digits: NACA 4-digit code, e.g. "4418".

    Returns:
        Tuple (m, p, t) suitable for naca_profile.
    """
    return int(digits[0]) / 100.0, int(digits[1]) / 10.0, int(digits[2:]) / 100.0


def naca_profile(m: float, p: float, t: float, n: int = 60) -> NacaPoints:
    """Closed airfoil outline from continuous NACA parameters.

    Accepts interpolated (non-integer) m, p, t values, which allows smooth
    profile variation along the blade span.

    Args:
        m: Maximum camber as a fraction of chord (e.g. 0.04 for 4%).
        p: Chordwise position of maximum camber (e.g. 0.4 for 40%).
        t: Maximum thickness as a fraction of chord (e.g. 0.18 for 18%).
        n: Number of cosine-spaced sample points per surface side.
    """
    return _naca_compute(m, p, t, n)


def naca_points(digits: str, n: int = 60) -> NacaPoints:
    """Closed airfoil outline from a NACA 4-digit code.

    Args:
        digits: NACA 4-digit code, e.g. "4418" for M=4%, P=40%, T=18%.
        n: Number of cosine-spaced sample points per surface side.
    """
    m, p, t = _parse_naca(digits)
    return _naca_compute(m, p, t, n)


def pts_to_face(
    pts_2d: NacaPoints, r: float, chord: float, twist_deg: float
) -> bd.Face:
    """Place a normalised 2-D profile as a build123d Face at spanwise position r.

    Transformation applied to each point (x, y):
      xs = (x - 0.5) * chord    (midchord at the span axis)
      ys = y * chord
      rotate by twist_deg around the z-axis
      place in the plane z = r

    Two separate splines are used (upper LE to TE, lower TE to LE) so the
    trailing edge cusp is geometrically sharp. A single periodic spline would
    enforce tangent continuity there and produce sawtooth artefacts.

    Args:
        pts_2d: Normalised profile points as returned by naca_points.
        r: Spanwise position in millimetres; the face is placed at z = r.
        chord: Chord length in millimetres.
        twist_deg: Rotation around the z-axis in degrees.
    """
    angle = np.radians(twist_deg)

    # Scale and rotate each normalised point into the blade coordinate system.
    # Subtracting 0.5 before scaling centres the chord on the z-axis.
    def tr(x: float, y: float) -> tuple[float, float, float]:
        xs = (x - 0.5) * chord
        ys = y * chord
        return (
            float(xs * np.cos(angle) - ys * np.sin(angle)),
            float(xs * np.sin(angle) + ys * np.cos(angle)),
            r,
        )

    pts_3d: list[bd.VectorLike] = [tr(x, y) for x, y in pts_2d]

    # The point with the largest x-coordinate is the trailing edge.
    # Everything up to (and including) it is the upper surface; the rest is lower.
    te_idx = max(range(len(pts_2d)), key=lambda i: pts_2d[i][0])
    upper_pts = pts_3d[: te_idx + 1]
    lower_pts = pts_3d[te_idx:] + [pts_3d[0]]  # close back to LE

    # Uniform index-based parameters force the loft to match the i-th point of one
    # section to the i-th point of the next, regardless of arc-length differences
    # between thick and thin profiles.
    def uniform(n: int) -> list[float]:
        return [i / (n - 1) for i in range(n)]

    e_upper = bd.Edge.make_spline(upper_pts, parameters=uniform(len(upper_pts)))
    e_lower = bd.Edge.make_spline(lower_pts, parameters=uniform(len(lower_pts)))
    faces = bd.make_face([e_upper, e_lower]).faces()
    assert len(faces) == 1
    return faces[0]


def _inner_naca(naca: str, chord: float, wall: float) -> str:
    """Reduce a NACA 4-digit code so that subtraction of the resulting inner profile
    gives a wall of thickness `wall` mm at the upper/lower surface maximum.

    Derivation: we want
        inner_half_height = outer_half_height - wall
        inner_tt * chord_inner / 100 / 2 = outer_tt * chord / 100 / 2 - wall
    Solving for inner_tt (as a percentage):
        inner_tt = (chord * tt - 200 * wall) / (chord - 2 * wall)

    Camber digits (M and P) are left unchanged.
    """
    tt_outer = int(naca[2:])
    chord_inner = chord - 2 * wall
    tt_inner = max(1, round((chord * tt_outer - 200 * wall) / chord_inner))
    return f"{naca[:2]}{tt_inner:02d}"


def _circular_face_aligned(
    r: float, radius: float, twist_deg: float, n: int = 60
) -> bd.Face:
    """Circular cross-section whose spline start matches the leading-edge direction of naca_points.

    A standard bd.Wire.make_circle() starts at (radius, 0) in the xy-plane, while
    naca_points starts at the leading edge (angle pi + twist). Lofting a circle and
    a profile with different parametric start points twists the loft surface.
    This function builds the circle as a periodic Spline with the same winding and
    start direction as naca_points, preventing that twist.

    Args:
        r: Spanwise position in millimetres; the face is placed at z = r.
        radius: Circle radius in millimetres.
        twist_deg: Angle of the leading-edge direction in degrees; keeps the
            parametric start point aligned with the profile faces in the loft.
        n: Number of spline points per half-circle.
    """
    twist = np.radians(twist_deg)

    # Split into two half-circles so the circle has the same two-edge wire structure
    # as the airfoil profiles (upper + lower). This ensures the loft connects them
    # without introducing a twist at the transition from flange to blade.
    angles_upper = np.linspace(np.pi + twist, twist, n + 1)
    angles_lower = np.linspace(twist, twist - np.pi, n + 1)

    def circle_pts(angles: np.ndarray) -> list[bd.Vector]:
        return [
            bd.Vector(float(radius * np.cos(a)), float(radius * np.sin(a)), r)
            for a in angles
        ]

    with bd.BuildLine() as bl:
        bd.Spline(*circle_pts(angles_upper))
        bd.Spline(*circle_pts(angles_lower))

    faces = bd.make_face(bl.wire().edges()).faces()
    assert len(faces) == 1
    return faces[0]


@dataclass
class SpanParams:
    circles: list[bd.Face]
    """Two aligned circle faces at the root (smooth flange transition)."""
    r_vals: np.ndarray
    """Spanwise position of each section (mm)."""
    chords: np.ndarray
    """Chord length at each section (mm)."""
    twists: np.ndarray
    """Twist angle at each section (degrees)."""
    ms: np.ndarray
    """NACA camber m at each section."""
    ps: np.ndarray
    """NACA camber position p at each section."""
    ts: np.ndarray
    """NACA thickness t at each section."""


def _span_params(p: BladeParam) -> SpanParams:
    """Precompute all spanwise geometry arrays and root circle faces for loft_sections.

    All sections — including the root cylindrical portion — are built with
    _circular_face_aligned so every face in the loft has the same Spline edge type.
    A separate bd.Cylinder is not needed and would introduce a Spline-vs-Circle
    junction that creates sliver faces in boolean operations.
    """
    circles: list[bd.Face] = [
        _circular_face_aligned(0.0, p.flange_radius, p.twist_root),
        _circular_face_aligned(10.0 * bd.CM, p.flange_radius, p.twist_root),
        _circular_face_aligned(p.flange_length, p.flange_radius, p.twist_root),
        _circular_face_aligned(
            p.flange_length + 20.0 * bd.CM, p.flange_radius, p.twist_root
        ),
    ]

    m0, p0, t0 = _parse_naca(p.naca_root)
    m1, p1, t1 = _parse_naca(p.naca_tip)

    # Evenly spaced section positions along the span, excluding the flange end.
    r_vals = np.linspace(p.flange_length, p.span, p.n_sections + 1)[1:]
    r_hat = (r_vals - p.flange_length) / (p.span - p.flange_length)

    # Shoulder chord distribution: linear ramp up to chord_max, then taper to tip.
    chord_flange = 2.0 * p.flange_radius
    chords = np.where(
        r_vals <= p.r_shoulder,
        chord_flange
        + (p.chord_max - chord_flange)
        * (r_vals - p.flange_length)
        / (p.r_shoulder - p.flange_length),
        p.chord_max
        + (p.chord_tip - p.chord_max)
        * (r_vals - p.r_shoulder)
        / (p.span - p.r_shoulder),
    )

    # All spanwise parameters interpolated linearly between root and tip values.
    twists = p.twist_root + (p.twist_tip - p.twist_root) * r_hat
    ms = m0 + (m1 - m0) * r_hat
    ps = p0 + (p1 - p0) * r_hat
    ts = t0 + (t1 - t0) * r_hat

    return SpanParams(
        circles=circles,
        r_vals=r_vals,
        chords=chords,
        twists=twists,
        ms=ms,
        ps=ps,
        ts=ts,
    )


if __name__ == "__main__":
    import ocp_vscode

    pts = naca_points("4418")
    face = pts_to_face(pts, r=0, chord=1000, twist_deg=0)
    ocp_vscode.show(face)
