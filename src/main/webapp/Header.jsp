<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-icons.css"> --%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">

<style>
    :root {
        --cs-bg: #f4f7fb;
        --cs-surface: rgba(255, 255, 255, 0.82);
        --cs-surface-strong: #ffffff;
        --cs-border: rgba(15, 23, 42, 0.08);
        --cs-text: #162033;
        --cs-muted: #5f6f86;
        --cs-primary: #0f6fff;
        --cs-primary-deep: #0948b3;
        --cs-accent: #12b981;
        --cs-warning: #f59e0b;
        --cs-shadow: 0 18px 45px rgba(15, 23, 42, 0.08);
        --cs-radius: 22px;
    }

    mark {
        background-color: #fff3cd;
        color: #856404;
        font-weight: 700;
        border-radius: 4px;
        padding: 0.05rem 0.25rem;
    }

    body {
        font-family: 'Manrope', sans-serif;
        color: var(--cs-text);
        background:
            radial-gradient(circle at top left, rgba(15, 111, 255, 0.12), transparent 28%),
            radial-gradient(circle at top right, rgba(18, 185, 129, 0.10), transparent 22%),
            linear-gradient(180deg, #f8fbff 0%, var(--cs-bg) 100%);
        min-height: 100vh;
    }

    pre, code {
        font-family: 'JetBrains Mono', monospace;
    }

    .card,
    .modal-content,
    .dropdown-menu,
    .alert,
    .form-control,
    .form-select,
    .input-group-text,
    .btn,
    .toast {
        border-radius: 18px;
    }

    .card,
    .modal-content,
    .dropdown-menu,
    .toast {
        border: 1px solid var(--cs-border);
        box-shadow: var(--cs-shadow);
    }

    .btn {
        font-weight: 700;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--cs-primary) 0%, var(--cs-primary-deep) 100%);
        border: none;
    }

    .btn-primary:hover,
    .btn-primary:focus {
        background: linear-gradient(135deg, #2280ff 0%, #0a4fd1 100%);
    }

    .form-control,
    .form-select {
        border: 1px solid rgba(15, 23, 42, 0.12);
        padding: 0.75rem 0.95rem;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: rgba(15, 111, 255, 0.4);
        box-shadow: 0 0 0 0.2rem rgba(15, 111, 255, 0.12);
    }
</style>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<%-- <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
 --%>